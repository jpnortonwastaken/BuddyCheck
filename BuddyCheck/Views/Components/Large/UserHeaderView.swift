//
//  UserHeaderView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct UserHeaderView: View {
    
    // MARK: - Properties (3)
    
    /// The user whose information is displayed.
    let user: User
    
    /// The action triggered when the user logs out.
    let logoutAction: () -> Void
    
    /// Tracks whether the logout confirmation alert is visible.
    @State private var showLogoutConfirmation = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                profilePicture
                
                userInfo
                
                Spacer()
                
                logoutButton
            }
        }
        .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
            alertActions
        }
    }
    
    // MARK: - Subviews (4)
    
    /// The profile picture view for the user.
    private var profilePicture: some View {
        ProfilePictureView(user: user, size: 40)
    }
    
    /// The user's information, including name and email.
    private var userInfo: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .bold()
            
            Text(user.email)
                .bold()
                .foregroundColor(Color.customGreyColorTextWeak)
                .lineLimit(1) // Restrict to a single line
                .truncationMode(.tail) // Truncate with ellipsis if too long
        }
    }
    
    /// The logout button.
    private var logoutButton: some View {
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
    
    /// The alert actions for the logout confirmation.
    private var alertActions: some View {
        Group {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                logoutAction()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    UserHeaderView(
        user: User.mockAlice,
        logoutAction: {
            print("Logout confirmed")
        }
    )
    .padding(.horizontal, 20)
}
