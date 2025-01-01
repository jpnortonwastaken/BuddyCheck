//
//  Checkins.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

// MARK: - Checkin Model

/// Represents a check-in by a user in a project.
struct Checkin: Identifiable, Codable, Hashable {
    
    // MARK: - Properties
    
    var id: UUID
    var project_id: UUID
    var user_id: UUID
    var created_at: String
}
