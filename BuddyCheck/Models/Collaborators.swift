//
//  CollaboratorModel.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

struct Collaborator: Identifiable, Codable {
    var id: UUID
    var project_id: UUID
    var user_id: UUID
    var role: String
    var joined_at: String
}
