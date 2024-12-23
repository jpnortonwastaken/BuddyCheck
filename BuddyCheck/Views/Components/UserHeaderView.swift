//
//  UserHeaderView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct UserHeaderView: View {
    let user: User
    let logoutAction: () -> Void
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        VStack {
            HStack {
                ProfilePictureView(user: user, size: 40)
                
                VStack(alignment: .leading) {
                    Text(user.name)
                        .bold()
                    Text(user.email)
                        .bold()
                        .foregroundColor(Color.customGreyColorTextWeak)
                        .lineLimit(1) // Restrict to a single line
                        .truncationMode(.tail) // Truncate with ellipsis if too long
                }
                
                Spacer()
                
                CustomButton(
                    text: "Log out",
                    foregroundColor: Color.red,
                    backgroundColor: Color.red.opacity(0.18),
                    paddingHorizontal: 16,
                    paddingVertical: 6,
                    action: {
                        showLogoutConfirmation = true
                    }
                )
            }
        }
        .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                logoutAction()
            }
        }
    }
}

#Preview {
    UserHeaderView(
        user: User.mockAlice,
        logoutAction: {
            print("Logout confirmed")
        }
    )
    .padding(.horizontal, 20)
}
