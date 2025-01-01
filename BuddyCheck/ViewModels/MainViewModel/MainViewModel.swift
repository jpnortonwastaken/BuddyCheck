//
//  MainViewModel.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI
import GoogleSignIn
import PostgREST

/// The primary view model for managing user authentication and project data.
///
/// This class is split into multiple extensions for better organization:
///  - `MainViewModel+Auth` for sign-in and authentication-related methods.
///  - `MainViewModel+Projects` for fetching and updating project and collaborator data.
///  - Additional domain-specific extensions as needed.
@MainActor
class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties (3)
    
    /// The currently authenticated user, if any.
    @Published var currentUser: User?
    
    /// The list of projects for the logged-in user.
    @Published var projects: [Project] = []
    
    /// Whether the user sign-in process is currently in progress.
    @Published var isLoadingUser: Bool = true
    
    // MARK: - Computed Properties / Helpers (1)
    
    /// Returns the current user's ID, or `nil` if not signed in.
    func getCurrentUserID() -> UUID? {
        currentUser?.id
    }
}
