//
//  ProjectView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct ProjectView: View {
    
    // MARK: - Properties (5)
    
    let project: Project
    let checkIn: (Project) -> Void
    let unCheckIn: (Project) -> Void
    let getCurrentUserID: () -> UUID?
    
    @State private var isCheckedIn = false
    
    // MARK: - Computed Properties (2)
    
    var streakText: String {
        let streak = StreakCalculator.calculateStreak(for: project.collaborators)
        return "\(streak)"
    }
    
    var isTodayComplete: Bool {
        let totalCollaborators = project.collaborators.count
        let todayCheckins = project.collaborators.filter { hasCheckedInToday($0.checkins) }.count
        return todayCheckins == totalCollaborators
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView
            
            collaboratorsView
            
            checkInOutButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.customGreyColorBackground)
        .cornerRadius(20)
        .onAppear(perform: initializeCheckInState)
    }
    
    // MARK: - Views (3)
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(project.title)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                if let streak = Int(streakText), streak > 0 {
                    StreakBadgeView(streakText: streakText, isTodayComplete: isTodayComplete)
                }
            }
            .frame(minHeight: 32)
            
            if let desc = project.description {
                Text(desc)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.customGreyColorTextStrong)
            }
        }
    }
    
    private var collaboratorsView: some View {
        VStack(spacing: 10) {
            ForEach(chunkArray(Array(project.collaborators), into: 3), id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row) { collaborator in
                        CollaboratorView(collaborator: collaborator)
                    }
                }
            }
        }
    }
    
    private var checkInOutButton: some View {
        CustomButton(
            text: isCheckedIn ? "Uncheck In" : "Check In",
            foregroundColor: isCheckedIn ? Color.customGreyColorTextStrong : Color.customButtonTextColor,
            backgroundColor: isCheckedIn ? Color.customGreyColorSuperWeak : Color.customButtonBackgroundColor,
            cornerRadius: 20,
            paddingVertical: 16,
            fullWidth: true,
            action: handleCheckIn
        )
    }
    
    // MARK: - Actions (2)
    
    private func handleCheckIn() {
        if isCheckedIn {
            unCheckIn(project)
        } else {
            checkIn(project)
        }
        isCheckedIn.toggle()
    }
    
    private func initializeCheckInState() {
        if let userId = getCurrentUserID() {
            isCheckedIn = project.collaborators.contains { collaborator in
                collaborator.user.id == userId && hasCheckedInToday(collaborator.checkins)
            }
        }
    }
    
    // MARK: - Helpers (2)
    
    private func chunkArray<T>(_ array: [T], into size: Int) -> [[T]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0..<min($0 + size, array.count)])
        }
    }
    
    private func hasCheckedInToday(_ checkins: [Checkin]) -> Bool {
        let isoFormatter = ISO8601DateFormatter()
        let today = Calendar.current.startOfDay(for: Date())
        return checkins.contains { checkin in
            if let date = isoFormatter.date(from: checkin.created_at) {
                return Calendar.current.isDate(date, inSameDayAs: today)
            }
            return false
        }
    }
}

// MARK: - Previews

#Preview {
    ProjectView(
        project: Project.mockProject1,
        checkIn: MockFunctions.mockCheckIn,
        unCheckIn: MockFunctions.mockUnCheckIn,
        getCurrentUserID: MockFunctions.mockGetCurrentUserID
    )
    .padding(16)
}
