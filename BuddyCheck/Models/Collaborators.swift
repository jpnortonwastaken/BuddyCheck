//
//  Collaborators.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

struct Collaborator: Identifiable, Codable, Hashable {
    var id: UUID
    var project_id: UUID
    var role: String
    var joined_at: String
    var user: User
    var checkins: [Checkin]
}

