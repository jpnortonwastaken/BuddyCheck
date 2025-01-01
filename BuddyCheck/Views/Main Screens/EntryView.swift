//
//  EntryView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import SwiftUI

struct EntryView: View {
    
    // MARK: - Properties (1)
    
    /// The shared MainViewModel instance.
    @EnvironmentObject var viewModel: MainViewModel
    
    // MARK: - Computed Properties (2)
    
    /// Check if the ViewModel is currently loading the user.
    private var isLoadingUser: Bool {
        viewModel.isLoadingUser
    }
    
    /// Check if there is a logged-in user.
    private var hasCurrentUser: Bool {
        viewModel.currentUser != nil
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()
            
            VStack {
                if isLoadingUser {
                    // Show loading spinner while user data is loading
                    LoadingView(alignment: .center)
                } else {
                    // Show the main app view or login screen based on user authentication
                    if hasCurrentUser {
                        MainView()
                            .environmentObject(viewModel)
                    } else {
                        LoginView()
                            .environmentObject(viewModel)
                    }
                }
            }
            .customTopRoundedCorners()
        }
    }
}

// MARK: - Custom Modifier (1)

private extension View {
    /// A custom modifier for applying rounded corners with edge ignoring.
    func customTopRoundedCorners() -> some View {
        self
            .clipShape(RoundedRectangle(cornerRadius: 44, style: .continuous))
            .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Preview

#Preview {
    // Simulate a test scenario for EntryView
    let testViewModel = MainViewModel()
    testViewModel.isLoadingUser = false // Set to true to test loading state
    testViewModel.currentUser = nil // Set to User.mockAlice to test a logged-in state
    testViewModel.projects = [Project.mockProject1, Project.mockProject2]
    
    return EntryView()
            .environmentObject(testViewModel)
}
