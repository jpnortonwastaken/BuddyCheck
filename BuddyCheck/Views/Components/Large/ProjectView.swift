//
//  ProjectView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct ProjectView: View {
    
    // MARK: - Properties (6)
    
    @EnvironmentObject var viewModel: MainViewModel
    
    let project: Project
    
    @State private var isCheckedIn = false
    @State private var isLoading = false  // track button loading state
    
    @State private var rippleOrigin: CGPoint = .zero
    @State private var rippleTrigger: Int = 0
    
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
        .coordinateSpace(name: "ProjectViewRipple")
        .modifier(RippleEffect(at: rippleOrigin, trigger: rippleTrigger))
        .onPressingChanged { point in
            guard let point = point else { return }
            rippleOrigin = point
        }
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
            text: isLoading
                ? "Loading..."
                : (isCheckedIn ? "Uncheck In" : "Check In"),
            
            foregroundColor:
                //isLoading ? .gray :
                (isCheckedIn
                    ? Color.customGreyColorTextStrong
                    : Color.customButtonTextColor),
            
            backgroundColor:
                //isLoading ? Color.secondary :
                (isCheckedIn
                    ? Color.customGreyColorSuperWeak
                    : Color.customButtonBackgroundColor),
            
            cornerRadius: 20,
            paddingVertical: 16,
            fullWidth: true,
            
            // Optionally disable the button while loading
            action: {
                handleCheckInOut()
                if (isCheckedIn == false) {
                    rippleTrigger += 1
                }
            }
        )
        .disabled(isLoading)
    }
    
    // MARK: - Actions (2)
    
    private func handleCheckInOut() {
        // Toggle the loading state on immediately so the UI updates
        isLoading = true
        
        Task {
            if isCheckedIn {
                await viewModel.unCheckIn(project: project)
                isCheckedIn = false
            } else {
                await viewModel.checkIn(project: project)
                isCheckedIn = true
            }
            
            // Done loading
            isLoading = false
            
            //rippleTrigger += 1
        }
    }
    
    private func initializeCheckInState() {
        if let userId = viewModel.getCurrentUserID() {
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
    // Create a test view model
    let testViewModel = MainViewModel()
    // Optionally fill it with some test data:
    testViewModel.currentUser = User.mockAlice
    testViewModel.projects = [Project.mockProject1] // So we have something to show

    return ProjectView(project: Project.mockProject1)
        .environmentObject(testViewModel)
        .padding(16)
}
