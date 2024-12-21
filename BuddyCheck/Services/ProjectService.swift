//
//  ProjectService.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import Foundation
import Supabase

final class ProjectService {
    func fetchProjectsWithEverything() async throws -> [Project] {
        return try await supabase
            .from("projects")
            .select("*, collaborators(*, user:users(id,name,email), checkins(*))")
            .execute()
            .value
    }
}
