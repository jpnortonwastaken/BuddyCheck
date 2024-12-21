//
//  Supabase.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/17/24.
//

import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: URL(string: Secrets.supabaseURL)!,
    supabaseKey: Secrets.supabaseKey
)
