//
//  MainView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    /// Tracks whether we’ve **loaded** the projects at least once.
    @State private var hasLoadedProjects = false
    
    /// Tracks whether we’re showing our *custom* “initial load” spinner.
    @State private var isLoadingInitialData = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Header
            if let user = viewModel.currentUser {
                UserHeaderView(user: user, logoutAction: {
                    viewModel.logOutUser()
                })
            }
            
            // 1) If it's our first load and we're still loading, show a custom spinner
            if isLoadingInitialData {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.customGreyColorTextStrong))
                        .scaleEffect(1.5)
                        .padding(.top, 100)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.customDynamicBackgroundColor)
            } else {
                // Project List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // 2) If we've loaded and there's nothing, show an empty state
                        if viewModel.projects.isEmpty {
                            VStack(spacing: 8) {
                                Text("No Projects Found")
                                    .font(.headline)
                                    .foregroundColor(Color.customGreyColorTextWeak)
                                Text("Pull down to refresh or add a new project.")
                                    .font(.subheadline)
                                    .foregroundColor(Color.customGreyColorTextWeak)
                            }
                            .padding(.top, 32)
                            
                            // 3) Otherwise, list out the projects
                        } else {
                            ForEach(viewModel.projects) { project in
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
                                    getCurrentUserID: { viewModel.getCurrentUserID()
                                    }
                                )
                            }
                        }
                    }
                    .padding(.bottom, 200)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity)
                }
                .cornerRadius(20)
                .refreshable {
                    /// If user pulls to refresh, just fetch again.
                    await fetchProjects(initialLoad: false)
                }
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .background(Color.customDynamicBackgroundColor)
        // 5) On first appearance, do an initial fetch
        .task {
            if !hasLoadedProjects {
                isLoadingInitialData = true
                await fetchProjects(initialLoad: true)
                isLoadingInitialData = false
                hasLoadedProjects = true
            }
        }
    }
    
    /// Our single fetch function.
    private func fetchProjects(initialLoad: Bool) async {
        // Call the ViewModel method to do the actual fetching.
        // This method should NOT set any state variables itself.
        await viewModel.getProjects()
        // That’s it—no local “isRefreshing” needed,
        // because SwiftUI automatically handles the
        // spinning wheel for pull-to-refresh.
    }
}

#Preview {
    let vm = MainViewModel()
    vm.currentUser = User.mockAlice
    vm.projects = [Project.mockProject1, Project.mockProject2]
    return MainView(viewModel: vm)
}
