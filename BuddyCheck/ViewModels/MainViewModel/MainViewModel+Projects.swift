//
//  MainViewModel+Projects.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/31/24.
//

import SwiftUI
import PostgREST

extension MainViewModel {
    
    // MARK: - Projects: Fetch & Update
    
    /// Retrieves all projects for the current user from Supabase.
    func getProjects() async {
        do {
            let userId = currentUser?.id ?? UUID()  // or return early if needed
            self.projects = try await fetchUserProjectsFromSupabase(userId: userId)
            //print("✅ Updated projects in view model")
        } catch {
            print("❌ Error fetching projects: \(error)")
        }
    }
    
    /// Fetches the projects from Supabase for the given user ID.
    ///
    /// - Note: This calls multiple subroutines (`fetchProjectIdsForUser`, `fetchCollaboratorsForProjects`)
    ///         and merges the results to build `[Project]` with collaborators.
    func fetchUserProjectsFromSupabase(userId: UUID) async throws -> [Project] {
        do {
            let projectIds = try await fetchProjectIdsForUser(userId: userId)
            
            let response = try await supabase
                .from("projects")
                .select("""
                    id,
                    title,
                    description,
                    created_by:users(id, name, email, photo_url, created_at),
                    created_at
                """)
                .in("id", values: projectIds.map { $0.uuidString })
                .execute()
            
            var projects = try JSONDecoder().decode([Project].self, from: response.data)
            
            // Attach collaborators to projects
            let collaboratorsByProjectId = try await fetchCollaboratorsForProjects(projectIds: projectIds)
            for i in projects.indices {
                projects[i].collaborators = collaboratorsByProjectId[projects[i].id] ?? []
            }
            
            return projects
        } catch {
            throw error
        }
    }
    
    /// Returns an array of project UUIDs in which the specified user is a collaborator.
    func fetchProjectIdsForUser(userId: UUID) async throws -> [UUID] {
        do {
            let response = try await supabase
                .from("collaborators")
                .select("project_id")
                .eq("user_id", value: userId.uuidString)
                .execute()
            
            let projectIds = try JSONDecoder().decode([[String: String]].self, from: response.data)
            return projectIds.compactMap { row in
                guard let projectId = row["project_id"] else { return nil }
                return UUID(uuidString: projectId)
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Collaborators & Check-Ins
    
    /// For each project in `projectIds`, fetches all collaborators. Also fetches check-ins so each `Collaborator` can have its check-ins attached.
    func fetchCollaboratorsForProjects(projectIds: [UUID]) async throws -> [UUID: [Collaborator]] {
        do {
            let response = try await supabase
                .from("collaborators")
                .select("""
                    id,
                    project_id,
                    user:users(id, name, email, photo_url, created_at),
                    role,
                    joined_at
                """)
                .in("project_id", values: projectIds.map { $0.uuidString })
                .execute()
            
            var collaborators = try JSONDecoder().decode([Collaborator].self, from: response.data)
            
            // Also fetch and group check-ins
            let checkinsByProjectAndUser = try await fetchCheckinsForProjects(projectIds: projectIds)
            
            // Attach check-ins to each collaborator
            for i in collaborators.indices {
                let projectId = collaborators[i].project_id
                let userId = collaborators[i].user.id
                collaborators[i].checkins = checkinsByProjectAndUser[projectId]?[userId] ?? []
            }
            
            // Return grouped by project ID
            return Dictionary(grouping: collaborators, by: { $0.project_id })
        } catch {
            throw error
        }
    }
    
    /// Fetches all check-ins for the given `projectIds`. Returns a nested dictionary keyed by `[projectID][userID] = [Checkin]`.
    func fetchCheckinsForProjects(projectIds: [UUID]) async throws -> [UUID: [UUID: [Checkin]]] {
        do {
            let response = try await supabase
                .from("checkins")
                .select("""
                    id,
                    project_id,
                    user_id,
                    created_at
                """)
                .in("project_id", values: projectIds.map { $0.uuidString })
                .execute()
            
            let checkins = try JSONDecoder().decode([Checkin].self, from: response.data)
            
            // Group check-ins by project ID & user ID
            var groupedCheckins: [UUID: [UUID: [Checkin]]] = [:]
            for checkin in checkins {
                let projectId = checkin.project_id
                let userId = checkin.user_id
                if groupedCheckins[projectId] == nil {
                    groupedCheckins[projectId] = [:]
                }
                if groupedCheckins[projectId]?[userId] == nil {
                    groupedCheckins[projectId]?[userId] = []
                }
                groupedCheckins[projectId]?[userId]?.append(checkin)
            }
            
            return groupedCheckins
        } catch {
            throw error
        }
    }
    
    // MARK: - Check-In / Un-Check-In
    
    /// Performs a "check-in" for the specified project, if the user has not already checked in today.
    func checkIn(project: Project) async {
        // Simulate a wait for demonstration
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        guard let userID = currentUser?.id else {
            print("❌ User not signed in.")
            return
        }
        
        let now = Date()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let isoDate = isoFormatter.string(from: now)
        print("ℹ️ Checking in for project: \(project.title), userID: \(userID), date: \(isoDate)")
        
        do {
            // Query for today's check-ins
            let startOfDay = isoFormatter.string(from: Calendar.current.startOfDay(for: now))
            let existingCheckins = try await supabase
                .from("checkins")
                .select("*")
                .eq("project_id", value: project.id.uuidString)
                .eq("user_id", value: userID.uuidString)
                .gte("created_at", value: startOfDay)
                .execute()

            let foundCheckins = try JSONDecoder().decode([Checkin].self, from: existingCheckins.data)
            guard foundCheckins.isEmpty else {
                print("ℹ️ User already checked in today for project: \(project.title)")
                return
            }

            // Insert new check-in
            let newCheckin = Checkin(
                id: UUID(),
                project_id: project.id,
                user_id: userID,
                created_at: isoDate
            )

            try await supabase
                .from("checkins")
                .insert(newCheckin)
                .execute()
            
            print("✅ Successfully checked in for project: \(project.title)")
            
            // Update local data
            if let projectIndex = projects.firstIndex(where: { $0.id == project.id }) {
                if let collaboratorIndex = projects[projectIndex]
                    .collaborators
                    .firstIndex(where: { $0.user.id == userID }) {
                    
                    projects[projectIndex].collaborators[collaboratorIndex].checkins.append(newCheckin)
                }
            }
            
        } catch {
            print("❌ Error during check-in: \(error)")
        }
    }
    
    /// Performs an "un-check-in" for the specified project, if a check-in exists today.
    func unCheckIn(project: Project) async {
        // Simulate a wait for demonstration
        try? await Task.sleep(nanoseconds: 5_000_000_000)

        guard let userID = currentUser?.id else {
            print("❌ User not signed in.")
            return
        }
        
        let now = Date()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let isoStartOfDay = isoFormatter.string(from: Calendar.current.startOfDay(for: now))
        print("ℹ️ Unchecking in for project: \(project.title), userID: \(userID), date: \(isoStartOfDay)")
        
        do {
            // Query for today's check-ins
            let existingCheckins = try await supabase
                .from("checkins")
                .select("*")
                .eq("project_id", value: project.id.uuidString)
                .eq("user_id", value: userID.uuidString)
                .gte("created_at", value: isoStartOfDay)
                .execute()
            
            let foundCheckins = try JSONDecoder().decode([Checkin].self, from: existingCheckins.data)
            guard let checkinToDelete = foundCheckins.first else {
                print("ℹ️ No check-in found for today in project: \(project.title)")
                return
            }
            
            // Delete check-in
            try await supabase
                .from("checkins")
                .delete()
                .eq("id", value: checkinToDelete.id.uuidString)
                .execute()
            
            print("✅ Successfully unchecked in for project: \(project.title)")
            
            // Update local data
            if let projectIndex = projects.firstIndex(where: { $0.id == project.id }) {
                if let collaboratorIndex = projects[projectIndex]
                    .collaborators
                    .firstIndex(where: { $0.user.id == userID }) {
                    
                    projects[projectIndex].collaborators[collaboratorIndex].checkins
                        .removeAll(where: { $0.id == checkinToDelete.id })
                }
            }
            
        } catch {
            print("❌ Error during uncheck-in: \(error)")
        }
    }
}
