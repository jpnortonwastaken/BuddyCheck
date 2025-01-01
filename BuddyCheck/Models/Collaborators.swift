//
//  Collaborators.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import Foundation

// MARK: - Collaborator Model

/// Represents a collaborator in a project.
struct Collaborator: Identifiable, Codable, Hashable {
    
    // MARK: - Nested Types
    
    /// The role of the collaborator in the project.
    enum Role: String, Codable {
        case owner = "Owner"
        case collaborator = "Collaborator"
    }
    
    // MARK: - Properties
    
    var id: UUID
    var project_id: UUID
    var user: User
    var role: Role
    var joined_at: String
    var checkins: [Checkin]
    
    // MARK: - CodingKeys
    
    /// Maps the JSON keys to the struct properties for decoding/encoding.
    private enum CodingKeys: String, CodingKey {
        case id
        case project_id = "project_id"
        case user
        case role
        case joined_at = "joined_at"
        case checkins
    }
    
    // MARK: - Initializers
    
    /// Custom initializer for decoding JSON.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        project_id = try container.decode(UUID.self, forKey: .project_id)
        user = try container.decode(User.self, forKey: .user)
        role = try container.decode(Role.self, forKey: .role)
        joined_at = try container.decode(String.self, forKey: .joined_at)
        checkins = try container.decodeIfPresent([Checkin].self, forKey: .checkins) ?? [] // Default to empty array
    }
    
    /// Memberwise initializer for creating collaborators programmatically.
    init(
        id: UUID,
        project_id: UUID,
        user: User,
        role: Role,
        joined_at: String,
        checkins: [Checkin] = []
    ) {
        self.id = id
        self.project_id = project_id
        self.user = user
        self.role = role
        self.joined_at = joined_at
        self.checkins = checkins
    }
}
