//
//  ProfilePictureView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct ProfilePictureView: View {
    let user: User
    let size: CGFloat // Size of the image

    var body: some View {
        Group {
            if let url = user.photo_url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: size, height: size)
                    case .failure(_):
                        placeholder
                    case .empty:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
    }

    // Placeholder image for when the URL is missing or fails to load
    private var placeholder: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: size, height: size)
            .foregroundColor(Color.customGreyColorTextWeak)
    }
}

#Preview {
    ProfilePictureView(user: User.mockAlice, size: 160)
}
