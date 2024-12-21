//
//  CheckinsModel.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

struct Checkin: Identifiable, Codable {
    var id: UUID
    var project_id: UUID
    var user_id: UUID
    var datetime: String
}
