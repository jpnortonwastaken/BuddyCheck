//
//  Collaborators.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

struct Collaborator: Identifiable, Codable, Hashable {
    enum Role: String, Codable {
        case owner = "Owner"
        case collaborator = "Collaborator"
    }
    
    var id: UUID
    var project_id: UUID
    var user: User
    var role: Role
    var joined_at: String
    var checkins: [Checkin]
    
    // CodingKeys for mapping JSON fields to struct properties
    enum CodingKeys: String, CodingKey {
        case id
        case project_id
        case user
        case role
        case joined_at
        case checkins
    }

    // Custom init for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        project_id = try container.decode(UUID.self, forKey: .project_id)
        user = try container.decode(User.self, forKey: .user)
        role = try container.decode(Role.self, forKey: .role)
        joined_at = try container.decode(String.self, forKey: .joined_at)
        checkins = try container.decodeIfPresent([Checkin].self, forKey: .checkins) ?? [] // Default to empty array
    }
    
    // Reintroduce the memberwise initializer
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
