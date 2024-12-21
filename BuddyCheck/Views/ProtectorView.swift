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
                if viewModel.currentUser != nil {
                    MainView(viewModel: viewModel)
                } else {
                    LoginView(viewModel: viewModel)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 44, style: .continuous))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    let vm = MainViewModel()
    vm.currentUser = nil //User.mockAlice
    vm.projects = [Project.mockProject1, Project.mockProject2]
    return ProtectorView(viewModel: vm)
}
