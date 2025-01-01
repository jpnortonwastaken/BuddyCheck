//
//  MainViewModel.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import PostgREST

@MainActor
class MainViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var projects: [Project] = []
    @Published var isLoadingUser: Bool = true
    
    func getCurrentUserID() -> UUID? {
        return currentUser?.id
    }
    
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
            
            // Decode checkins
            let checkins = try JSONDecoder().decode([Checkin].self, from: response.data)
            
            // Group checkins by project ID and user ID
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
            
            //print("✅ Successfully fetched and grouped checkins.")
            return groupedCheckins
        } catch {
            print("❌ Error fetching checkins for projects: \(error)")
            throw error
        }
    }

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
            
            // Decode collaborators
            var collaborators = try JSONDecoder().decode([Collaborator].self, from: response.data)
            
            // Fetch and group checkins
            let checkinsByProjectAndUser = try await fetchCheckinsForProjects(projectIds: projectIds)
            
            // Attach checkins to collaborators
            for i in collaborators.indices {
                let collaborator = collaborators[i]
                let projectId = collaborator.project_id
                let userId = collaborator.user.id
                collaborators[i].checkins = checkinsByProjectAndUser[projectId]?[userId] ?? []
            }
            
            // Group collaborators by project ID
            return Dictionary(grouping: collaborators, by: { $0.project_id })
        } catch {
            print("❌ Error fetching collaborators for projects: \(error)")
            throw error
        }
    }

    func fetchUserProjectsFromSupabase(userId: UUID) async throws -> [Project] {
        do {
            // Fetch project IDs for the user
            let projectIds = try await fetchProjectIdsForUser(userId: userId)
            
            // Fetch projects
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
            
            // Decode projects
            var projects = try JSONDecoder().decode([Project].self, from: response.data)
            
            // Fetch collaborators for the projects
            let collaboratorsByProjectId = try await fetchCollaboratorsForProjects(projectIds: projectIds)
            
            // Attach collaborators to the respective projects
            for i in projects.indices {
                projects[i].collaborators = collaboratorsByProjectId[projects[i].id] ?? []
            }
            
            //print("✅ Successfully fetched \(projects.count) projects with collaborators and check-ins.")
            
            return projects
        } catch {
            print("❌ Error fetching user projects: \(error)")
            throw error
        }
    }
    
    func fetchProjectIdsForUser(userId: UUID) async throws -> [UUID] {
        do {
            let response = try await supabase
                .from("collaborators")
                .select("project_id")
                .eq("user_id", value: userId.uuidString)
                .execute()
            
            // Decode the project IDs
            let projectIds = try JSONDecoder().decode([[String: String]].self, from: response.data)
            
            return projectIds.compactMap { row in
                guard let projectId = row["project_id"] else { return nil }
                return UUID(uuidString: projectId)
            }
        } catch {
            print("❌ Error fetching project IDs for user: \(error)")
            throw error
        }
    }
    
    private func dateString(_ date: Date) -> String {
        // Format date as "YYYY-MM-DD" for Supabase eq query
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func fetchUserFromSupabase(email: String) async throws -> User {
        do {
            let response = try await supabase
                .from("users")
                .select()
                .eq("email", value: email)
                .single()
                .execute()

            // Decode the returned user data
            let user = try JSONDecoder().decode(User.self, from: response.data)
            //print("✅ Fetched user: \(user)")
            return user
        } catch let error as PostgrestError where error.code == "PGRST116" {
            // Handle case where no user was found
            //print("ℹ️ No user found with email: \(email)")
            throw NSError(domain: "UserNotFoundError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user found with the given email."])
        } catch {
            // Handle other errors
            print("❌ Error executing query: \(error)")
            throw error
        }
    }

    func addUserToSupabase(email: String, name: String?, photoURL: URL?) async throws -> User {
        let newUser = User(
            id: UUID(),
            name: name ?? "Unknown",
            email: email,
            photo_url: photoURL,
            created_at: ISO8601DateFormatter().string(from: Date())
        )

        do {
            _ = try await supabase
                .from("users")
                .insert(newUser)
                .execute()
            
            //print("✅ User added successfully: \(newUser)")
            return newUser
        } catch {
            print("❌ Error adding user to Supabase: \(error)")
            throw error
        }
    }

    func fetchOrCreateUser(email: String, name: String?, photoURL: URL?) async throws -> User {
        do {
            // Try fetching the user
            return try await fetchUserFromSupabase(email: email)
        } catch let fetchError as NSError where fetchError.domain == "UserNotFoundError" {
            // If user not found, create the user
            return try await addUserToSupabase(email: email, name: name, photoURL: photoURL)
        } catch {
            // Propagate any other errors
            print("❌ Error in fetchOrCreateUser: \(error)")
            throw error
        }
    }

    func restorePreviousSignIn() {
        isLoadingUser = true // Start loading
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            Task {
                defer { self.isLoadingUser = false } // Always reset loading state
                
                guard let user = user else {
                    print("ℹ️ No previous user signed in.")
                    return
                }
                
                do {
                    self.currentUser = try await self.fetchOrCreateUser(
                        email: user.profile?.email ?? "",
                        name: user.profile?.name,
                        photoURL: user.profile?.imageURL(withDimension: 100)
                    )
                    print("✅ Successfully restored sign-in for: \(self.currentUser?.name ?? "Unknown")")
                } catch {
                    print("❌ Error restoring previous sign-in: \(error)")
                }
            }
        }
    }
    
    func signInWithGoogle(presenting viewController: UIViewController) {
        isLoadingUser = true // Start loading
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            Task {
                defer { self.isLoadingUser = false } // Always reset loading state
                
                guard let result = result else {
                    print("❌ Error during Google sign-in: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    self.currentUser = try await self.fetchOrCreateUser(
                        email: result.user.profile?.email ?? "",
                        name: result.user.profile?.name,
                        photoURL: result.user.profile?.imageURL(withDimension: 100)
                    )
                    print("✅ Successfully signed in as: \(self.currentUser?.name ?? "Unknown")")
                } catch {
                    print("❌ Error during Google sign-in: \(error)")
                }
            }
        }
    }
    
    func logOutUser() {
        GIDSignIn.sharedInstance.signOut()
        currentUser = nil
        projects = []
    }
    
    func getProjects() async {
        //try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
        
        do {
            let userId = currentUser?.id ?? UUID()
            self.projects = try await fetchUserProjectsFromSupabase(userId: userId)
            //print("✅ Updated projects in view model")
        } catch {
            print("❌ Error fetching projects: \(error)")
        }
    }
    
    func checkIn(project: Project) async {
        //try? await Task.sleep(nanoseconds: 5_000_000_000) // Simulate async work

        guard let userID = currentUser?.id else {
            print("❌ User not signed in.")
            return
        }

        let currentDate = Date()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC
        let isoDate = isoFormatter.string(from: currentDate)

        print("ℹ️ Checking in for project: \(project.title), userID: \(userID), date: \(isoDate)")

        do {
            // Query for today's check-ins
            let existingCheckins = try await supabase
                .from("checkins")
                .select("*")
                .eq("project_id", value: project.id.uuidString)
                .eq("user_id", value: userID.uuidString)
                .gte("created_at", value: "\(isoFormatter.string(from: Calendar.current.startOfDay(for: currentDate)))")
                .execute()

            let data = existingCheckins.data
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Query Result (Decoded): \(jsonString)")
//            }

            // Check if there are existing check-ins
            let checkins = try JSONDecoder().decode([Checkin].self, from: data)
            if !checkins.isEmpty {
                print("ℹ️ User already checked in today for project: \(project.title)")
                return
            }

            // Add the new check-in
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
                if let collaboratorIndex = projects[projectIndex].collaborators.firstIndex(where: { $0.user.id == userID }) {
                    projects[projectIndex].collaborators[collaboratorIndex].checkins.append(newCheckin)
                }
            }

        } catch {
            print("❌ Error during check-in: \(error)")
        }
    }
    
    func unCheckIn(project: Project) async {
        //try? await Task.sleep(nanoseconds: 5_000_000_000) // Simulate async work
        
        guard let userID = currentUser?.id else {
            print("❌ User not signed in.")
            return
        }

        let currentDate = Date()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC
        let isoStartOfDay = isoFormatter.string(from: Calendar.current.startOfDay(for: currentDate))

        print("ℹ️ Unchecking in for project: \(project.title), userID: \(userID), date: \(isoStartOfDay)")

        do {
            // Query for today's check-ins
            let existingCheckinsResponse = try await supabase
                .from("checkins")
                .select("*")
                .eq("project_id", value: project.id.uuidString)
                .eq("user_id", value: userID.uuidString)
                .gte("created_at", value: isoStartOfDay)
                .execute()

            let data = existingCheckinsResponse.data
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Query Result (Decoded): \(jsonString)")
//            }

            // Decode check-ins
            let checkins = try JSONDecoder().decode([Checkin].self, from: data)
            guard let checkinToDelete = checkins.first else {
                print("ℹ️ No check-in found for today in project: \(project.title)")
                return
            }

            // Delete the check-in
            try await supabase
                .from("checkins")
                .delete()
                .eq("id", value: checkinToDelete.id.uuidString)
                .execute()

            print("✅ Successfully unchecked in for project: \(project.title)")

            // Update local data
            if let projectIndex = projects.firstIndex(where: { $0.id == project.id }) {
                if let collaboratorIndex = projects[projectIndex].collaborators.firstIndex(where: { $0.user.id == userID }) {
                    // Remove the check-in from the local data
                    projects[projectIndex].collaborators[collaboratorIndex].checkins.removeAll(where: { $0.id == checkinToDelete.id })
                }
            }

        } catch {
            print("❌ Error during uncheck-in: \(error)")
        }
    }
}

extension Date {
    func toUTCString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
}
