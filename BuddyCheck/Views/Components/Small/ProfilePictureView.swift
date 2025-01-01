//
//  ProfilePictureView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct ProfilePictureView: View {
    
    // MARK: - Properties (2)
    
    /// The user whose profile picture is displayed.
    let user: User
    
    /// The size of the profile picture.
    let size: CGFloat
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if let url = user.photo_url {
                AsyncImage(url: url, content: asyncImageContent, placeholder: { placeholder })
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Subviews (2)
    
    /// The content for a successfully loaded image.
    private func asyncImageContent(image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: size, height: size)
    }
    
    /// Placeholder image for when the URL is missing or the image fails to load.
    private var placeholder: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: size, height: size)
            .foregroundColor(Color.customGreyColorTextWeak)
    }
}

// MARK: - Preview

#Preview {
    ProfilePictureView(user: User.mockAlice, size: 160)
}
