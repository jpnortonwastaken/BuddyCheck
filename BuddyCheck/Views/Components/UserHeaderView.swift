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
                        logoutAction()
                    }
                )
            }
        }
    }
}

#Preview {
    UserHeaderView(
        user: User.mockAlice,
        logoutAction: {
            print("Logout pressed")
        }
    )
    .padding(.horizontal, 20)
}
