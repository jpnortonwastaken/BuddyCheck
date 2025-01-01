//
//  CollaboratorView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct CollaboratorView: View {
    // MARK: - Properties (1)
    let collaborator: Collaborator

    // MARK: - Body
    var body: some View {
        HStack {
            ProfilePictureView(user: collaborator.user, size: 36)
                .accessibilityLabel("\(collaborator.user.name)'s profile picture")
            
            Spacer()
            
            if hasCheckedInToday(collaborator.checkins) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.green)
                    .padding(.trailing, 4)
                    .accessibilityLabel("\(collaborator.user.name) has checked in today")
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, minHeight: 40)
        .background(backgroundColor)
        .cornerRadius(.infinity)
        .overlay(
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(borderColor, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }

    // MARK: - Computed Properties (2)
    
    private var backgroundColor: Color {
        hasCheckedInToday(collaborator.checkins) ? Color.customGreenQuaternary : Color.customGreyColorSuperWeak
    }

    private var borderColor: Color {
        hasCheckedInToday(collaborator.checkins) ? Color.green : Color.customGreyColorTextStrong
    }

    // MARK: - Helper Functions (1)
    
    private func hasCheckedInToday(_ checkins: [Checkin]) -> Bool {
        let isoFormatter = ISO8601DateFormatter()
        let today = Calendar.current.startOfDay(for: Date())
        return checkins.contains { checkin in
            if let date = isoFormatter.date(from: checkin.created_at) {
                return Calendar.current.isDate(date, inSameDayAs: today)
            }
            return false
        }
    }
}

// MARK: - Preview

struct CollaboratorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            CollaboratorView(collaborator: Collaborator.mockCollaboratorAliceProject2)
            CollaboratorView(collaborator: Collaborator.mockCollaboratorCharlieProject1)
        }
        .padding(30)
        .background(Color.customDynamicBackgroundColor)
        .cornerRadius(30)
        .previewLayout(.sizeThatFits)
    }
}
