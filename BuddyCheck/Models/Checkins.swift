//
//  Checkins.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

struct Checkin: Identifiable, Codable, Hashable {
    var id: UUID
    var project_id: UUID
    var user_id: UUID
    var created_at: String
}
