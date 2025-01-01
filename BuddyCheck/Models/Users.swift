//
//  Users.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

// MARK: - User Model

/// Represents a user in the BuddyCheck app.
struct User: Identifiable, Codable, Hashable {
    
    // MARK: - Properties
    
    var id: UUID
    var name: String
    var email: String
    var photo_url: URL?
    var created_at: String
}
