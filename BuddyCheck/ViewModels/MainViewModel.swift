//
//  MainViewModel.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import Foundation
import SwiftUI
import GoogleSignIn

@MainActor
class MainViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var projects: [Project] = [Project.mockProject1, Project.mockProject2]
    
    private let projectService = ProjectService()
    
    func loadProjects() async {
        do {
            let fetchedProjects = try await projectService.fetchProjectsWithEverything()
            self.projects = fetchedProjects
        } catch {
            print("Error fetching projects: \(error)")
        }
    }
    
    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn {user, error in
            if let user {
                self.currentUser = .init(
                    id: UUID(),
                    name: user.profile?.name ?? "",
                    email: user.profile?.email ?? "",
                    photo_url: user.profile?.imageURL(withDimension: 100),
                    created_at: ISO8601DateFormatter().string(from: Date())
                )
            }
        }
    }
    
    func signInWithGoogle(presenting viewController: UIViewController) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: viewController
        ) { result, error in
            guard let result else {
                // inspect error
                return
            }
            self.currentUser = User.init(
                id: UUID(),
                name: result.user.profile?.name ?? "",
                email: result.user.profile?.email ?? "",
                photo_url: result.user.profile?.imageURL(withDimension: 100),
                created_at: ISO8601DateFormatter().string(from: Date())
            )
        }
    }
    
    func logOutUser() {
        GIDSignIn.sharedInstance.signOut()
        currentUser = nil
    }
    
    func hasCheckedInToday(_ checkins: [Checkin]) -> Bool {
        let isoFormatter = ISO8601DateFormatter()
        let today = Calendar.current.startOfDay(for: Date())
        return checkins.contains { checkin in
            if let date = isoFormatter.date(from: checkin.datetime) {
                return Calendar.current.isDate(date, inSameDayAs: today)
            }
            return false
        }
    }
}
