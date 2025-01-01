//
//  Supabase.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/17/24.
//

import Supabase
import Foundation

// MARK: - Supabase Configuration

/// A singleton instance of the Supabase client for interacting with the backend.
let supabase: SupabaseClient = {
    guard let url = URL(string: Secrets.supabaseURL) else {
        fatalError("Invalid Supabase URL provided in Secrets.")
    }
    guard !Secrets.supabaseKey.isEmpty else {
        fatalError("Supabase key is missing or invalid in Secrets.")
    }
    return SupabaseClient(
        supabaseURL: url,
        supabaseKey: Secrets.supabaseKey
    )
}()
