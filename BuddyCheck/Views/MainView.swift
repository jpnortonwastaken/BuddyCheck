//
//  MainView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            // UserHeaderView
            if let user = viewModel.currentUser {
                UserHeaderView(user: user, logoutAction: {
                    viewModel.logOutUser()
                })
            }
            
            // Projects List
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(viewModel.projects) { project in
                        VStack() {
                            ProjectView(project: project, hasCheckedInToday: viewModel.hasCheckedInToday)
                        }
                    }
                }
                .padding(.top, 16)
            }
            .cornerRadius(20)
            .task {
                await viewModel.loadProjects()
            }
            .refreshable {
                await viewModel.loadProjects()
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
        .background(Color.customDynamicBackgroundColor)
    }
}

#Preview {
    let vm = MainViewModel()
    vm.currentUser = User.mockAlice
    vm.projects = [Project.mockProject1, Project.mockProject2]
    return MainView(viewModel: vm)
}
