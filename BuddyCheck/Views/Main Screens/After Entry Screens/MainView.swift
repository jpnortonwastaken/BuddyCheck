//
//  MainView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties (3)
    
    /// The shared MainViewModel instance.
    @ObservedObject var viewModel: MainViewModel
    
    /// Tracks whether we’ve **loaded** the projects at least once.
    @State private var hasLoadedProjects = false
    
    /// Tracks whether we’re showing our *custom* “initial load” spinner.
    @State private var isLoadingInitialData = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Header
            if let user = viewModel.currentUser {
                userHeader(user: user)
            }
            
            // Content
            if isLoadingInitialData {
                LoadingView(alignment: .top)
                    .padding(.top, 100)
            } else {
                projectList
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .background(Color.customDynamicBackgroundColor)
        .task {
            if !hasLoadedProjects {
                isLoadingInitialData = true
                await fetchProjects(initialLoad: true)
                isLoadingInitialData = false
                hasLoadedProjects = true
            }
        }
    }
    
    // MARK: - Subviews (4)
    
    /// Header showing the user's information and logout option.
    private func userHeader(user: User) -> some View {
        UserHeaderView(user: user, logoutAction: {
            viewModel.logOutUser()
        })
    }
    
    /// List of projects or an empty state if there are none.
    private var projectList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                if viewModel.projects.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.projects) { project in
                        projectView(for: project)
                    }
                }
            }
            .padding(.bottom, 200)
            .padding(.top, 16)
            .frame(maxWidth: .infinity)
        }
        .cornerRadius(20)
        .refreshable {
            await fetchProjects(initialLoad: false)
        }
    }
    
    /// Single project view.
    private func projectView(for project: Project) -> some View {
        ProjectView(
            project: project,
            checkIn: { project in
                Task {
                    await viewModel.checkIn(project: project)
                }
            },
            unCheckIn: { project in
                Task {
                    await viewModel.unCheckIn(project: project)
                }
            },
            getCurrentUserID: {
                viewModel.getCurrentUserID()
            }
        )
    }
    
    /// View to display when there are no projects.
    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("No Projects Found")
                .font(.headline)
                .foregroundColor(Color.customGreyColorTextWeak)
            
            Text("Pull down to refresh or add a new project.")
                .font(.subheadline)
                .foregroundColor(Color.customGreyColorTextWeak)
        }
        .padding(.top, 68)
    }
    
    // MARK: - Methods (1)
    
    /// Fetches projects and updates the view.
    private func fetchProjects(initialLoad: Bool) async {
        await viewModel.getProjects()
    }
}

// MARK: - Preview

#Preview {
    let testViewModel = MainViewModel()
    testViewModel.currentUser = User.mockAlice // Set to nil to test a logged-out state
    testViewModel.projects = [Project.mockProject1, Project.mockProject2]
    
    return MainView(viewModel: testViewModel)
}
