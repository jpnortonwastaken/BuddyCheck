//
//  ProtectorView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import SwiftUI

struct ProtectorView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                if viewModel.isLoadingUser {
                    // Splash Screen or Loading Indicator
                    VStack {
                        Spacer()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.customGreyColorTextStrong))
                            .scaleEffect(1.5)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.customDynamicBackgroundColor)
                } else {
                    // Main or Login View
                    if viewModel.currentUser != nil {
                        MainView(viewModel: viewModel)
                    } else {
                        LoginView(viewModel: viewModel)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 44, style: .continuous))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    let vm = MainViewModel()
    //vm.isLoading = false
    vm.currentUser = nil //User.mockAlice
    vm.projects = [Project.mockProject1, Project.mockProject2]
    return ProtectorView(viewModel: vm)
}
