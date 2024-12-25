//
//  ProjectView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct ProjectView: View {
    let project: Project
    let checkIn: (Project) -> Void
    let unCheckIn: (Project) -> Void
    let getCurrentUserID: () -> UUID?
    
    @State private var isCheckedIn = false
    
    var streakText: String {
        let streak = calculateProjectStreak(collaborators: project.collaborators)
        return "\(streak)"
    }
    
    var isTodayComplete: Bool {
        let totalCollaborators = project.collaborators.count
        let todayCheckins = project.collaborators.filter { hasCheckedInToday($0.checkins) }.count
        return todayCheckins == totalCollaborators
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                HStack {
                    Text(project.title)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    if let streak = Int(streakText), streak > 0 {
                        Text("\(streakText)")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(isTodayComplete ? Color.white : Color.customGreyColorTextStrong)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .frame(minWidth: 30, minHeight: 30)
                            .background(isTodayComplete ? Color.orange : Color.customGreyColorSuperWeak)
                            .cornerRadius(.infinity)
                    }
                }
                
                if let desc = project.description {
                    Text(desc)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color.customGreyColorTextStrong)
                }
            }
            
            VStack(spacing: 10) {
                ForEach(chunkArray(Array(project.collaborators), into: 3), id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row) { collaborator in
                            HStack {
                                ProfilePictureView(user: collaborator.user, size: 36)
                                
                                Spacer()
                                
                                if hasCheckedInToday(collaborator.checkins) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(Color.green)
                                        .padding(.trailing, 4)
                                } else {
//                                    Image(systemName: "plus.circle.fill")
//                                        .resizable()
//                                        .frame(width: 26, height: 26)
//                                        .foregroundColor(Color.red)
//                                        .rotationEffect(.degrees(45))
//                                        .padding(.trailing, 4)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, minHeight: 40) // Equal width and consistent height
                            .background(
                                hasCheckedInToday(collaborator.checkins) ? Color.customGreenQuaternary : Color.customGreyColorSuperWeak
                            )
                            .cornerRadius(.infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(hasCheckedInToday(collaborator.checkins) ? Color.green : Color.customGreyColorTextStrong, lineWidth: 1)
                            )
                        }
                    }
                }
            }
            
            CustomButton(
                text: isCheckedIn ? "Uncheck In" : "Check In",
                foregroundColor: isCheckedIn ? Color.customGreyColorTextStrong : Color.customButtonTextColor,
                backgroundColor: isCheckedIn ? Color.customGreyColorSuperWeak : Color.customButtonBackgroundColor,
                cornerRadius: 20,
                paddingVertical: 16,
                fullWidth: true,
                action: {
                    if isCheckedIn {
                        unCheckIn(project)
                    } else {
                        checkIn(project)
                    }
                    isCheckedIn.toggle()
                }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.customGreyColorBackground)
        .cornerRadius(20)
        .onAppear {
            if let userId = getCurrentUserID() {
                isCheckedIn = project.collaborators.contains { collaborator in
                    collaborator.user.id == userId && hasCheckedInToday(collaborator.checkins)
                }
            }
        }
    }
    
    // Helper function to chunk array
    private func chunkArray<T>(_ array: [T], into size: Int) -> [[T]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0..<min($0 + size, array.count)])
        }
    }
    
    // Helper function to check if there is a checkin for today
    func hasCheckedInToday(_ checkins: [Checkin]) -> Bool {
        let isoFormatter = ISO8601DateFormatter()
        let today = Calendar.current.startOfDay(for: Date())
        return checkins.contains { checkin in
            if let date = isoFormatter.date(from: checkin.created_at) {
                return Calendar.current.isDate(date, inSameDayAs: today)
            }
            return false
        }
    }
    
    func calculateProjectStreak(collaborators: [Collaborator]) -> Int {
        let calendar = Calendar.current
        var dailyCheckinCounts: [Date: Int] = [:]

        // Collect all check-ins for the project, grouped by day
        for collaborator in collaborators {
            for checkin in collaborator.checkins {
                if let checkinDate = ISO8601DateFormatter().date(from: checkin.created_at) {
                    let day = calendar.startOfDay(for: checkinDate)
                    dailyCheckinCounts[day, default: 0] += 1
                }
            }
        }

        // Sort the days with check-ins
        let sortedDays = dailyCheckinCounts.keys.sorted(by: >)
        let totalCollaborators = collaborators.count
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDay = calendar.date(byAdding: .day, value: -1, to: today)!

        // Check if today is completed
        if dailyCheckinCounts[today] == totalCollaborators {
            streak += 1
        }

        // Calculate streak for previous days
        for day in sortedDays {
            // Skip today as it was already checked
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
}

#Preview {
    ProjectView(
        project: Project.mockProject1,
        checkIn: MockFunctions.mockCheckIn,
        unCheckIn: MockFunctions.mockUnCheckIn,
        getCurrentUserID: MockFunctions.mockGetCurrentUserID
    )
    .padding(16)
}
