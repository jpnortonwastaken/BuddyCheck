//
//  Projects.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import Foundation

// MARK: - Project Model

/// Represents a project in the BuddyCheck app.
struct Project: Identifiable, Codable, Hashable {
    
    // MARK: - Properties
    
    var id: UUID
    var title: String
    var description: String?
    var created_by: User
    var created_at: String
    var collaborators: [Collaborator]
    
    // MARK: - CodingKeys
    
    /// Maps the JSON keys to the struct properties for decoding/encoding.
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case created_by = "created_by"
        case created_at = "created_at"
        case collaborators
    }
    
    // MARK: - Initializers
    
    /// Custom initializer for decoding JSON.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        created_by = try container.decode(User.self, forKey: .created_by)
        created_at = try container.decode(String.self, forKey: .created_at)
        collaborators = try container.decodeIfPresent([Collaborator].self, forKey: .collaborators) ?? [] // Default to empty array
    }
    
    /// Custom memberwise initializer for creating projects programmatically.
    init(
        id: UUID,
        title: String,
        description: String? = nil,
        created_by: User,
        created_at: String,
        collaborators: [Collaborator] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.created_by = created_by
        self.created_at = created_at
        self.collaborators = collaborators
    }
}
