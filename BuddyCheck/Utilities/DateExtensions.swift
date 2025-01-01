//
//  DateExtensions.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/31/24.
//

import Foundation

extension Date {
    /// Converts `self` to a UTC ISO8601 string. Example: 2024-12-31T23:59:59Z
    func toUTCString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
}
