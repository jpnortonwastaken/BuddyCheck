//
//  UsersModel.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//


import Foundation

//struct User: Identifiable, Codable {
//    var id: UUID
//    var name: String
//    var email: String
//    var photo_url: String?
//    var created_at: String
//}

struct UserData: Codable, Identifiable {
    var id: UUID
    var name: String
    var email: String
}
