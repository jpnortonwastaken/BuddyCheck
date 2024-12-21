//
//  Projects.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

struct Project: Identifiable, Codable {
    var id: UUID
    var name: String
    var description: String?
    var created_by: User
    var created_at: String
    var collaborators: [Collaborator]
}
