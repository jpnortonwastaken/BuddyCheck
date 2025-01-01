//
//  StreakCalculator.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import Foundation

struct StreakCalculator {
    
    /// Calculates the current streak of consecutive days where all collaborators have checked in.
    /// - Parameters:
    ///   - collaborators: An array of collaborators associated with the project.
    ///   - calendar: The calendar to use for date calculations (default: `.current`).
    /// - Returns: The streak count as an `Int`.
    static func calculateStreak(for collaborators: [Collaborator], using calendar: Calendar = .current) -> Int {
        guard !collaborators.isEmpty else { return 0 }
        
        // Group check-ins by day
        let dailyCheckinCounts = groupCheckinsByDay(collaborators: collaborators, using: calendar)
        let totalCollaborators = collaborators.count
        let today = calendar.startOfDay(for: Date())
        
        // Initialize streak variables
        var streak = 0
        var currentDay = calendar.date(byAdding: .day, value: -1, to: today)!
        
        // Check if today is complete
        if dailyCheckinCounts[today] == totalCollaborators {
            streak += 1
        }
        
        // Calculate streak for previous days
        for day in dailyCheckinCounts.keys.sorted(by: >) {
            // Skip today as it's already checked
            if calendar.isDate(day, inSameDayAs: today) {
                continue
            }
            
            // Check if the day matches the current streak day
            if calendar.isDate(day, inSameDayAs: currentDay) {
                if dailyCheckinCounts[day] == totalCollaborators {
                    streak += 1
                    currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay)!
                } else {
                    break
                }
            }
        }
        
        return streak
    }
    
    // MARK: - Helper Methods (1)
    
    /// Groups check-ins by day and counts the number of check-ins per day.
    /// - Parameters:
    ///   - collaborators: The list of collaborators with their associated check-ins.
    ///   - calendar: The calendar to use for date calculations.
    /// - Returns: A dictionary mapping each day (`Date`) to the count of check-ins.
    private static func groupCheckinsByDay(collaborators: [Collaborator], using calendar: Calendar) -> [Date: Int] {
        var dailyCheckinCounts: [Date: Int] = [:]
        
        for collaborator in collaborators {
            for checkin in collaborator.checkins {
                if let checkinDate = ISO8601DateFormatter().date(from: checkin.created_at) {
                    let day = calendar.startOfDay(for: checkinDate)
                    dailyCheckinCounts[day, default: 0] += 1
                }
            }
        }
        
        return dailyCheckinCounts
    }
}
