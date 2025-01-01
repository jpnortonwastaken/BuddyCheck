//
//  StreakBadgeView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

/// A badge view that displays the streak count along with a fire icon.
struct StreakBadgeView: View {
    
    // MARK: - Properties (2)
    
    let streakText: String
    let isTodayComplete: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 4) {
            Image("FireIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(iconColor)
            
            Text(streakText)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(textColor)
                .accessibilityLabel("\(streakText) day streak")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .frame(minWidth: 28, minHeight: 28)
        .background(backgroundColor)
        .cornerRadius(.infinity)
        .accessibilityElement(children: .combine)
    }
    
    // MARK: - Computed Properties (3)
    
    private var iconColor: Color {
        isTodayComplete ? Color.orange : Color.customGreyColorTextStrong
    }
    
    private var textColor: Color {
        isTodayComplete ? Color.customSuperLightOrange : Color.customGreyColorTextStrong
    }
    
    private var backgroundColor: Color {
        isTodayComplete ? Color.orange.opacity(0.2) : Color.customGreyColorSuperWeak
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        StreakBadgeView(streakText: "5", isTodayComplete: true)
        StreakBadgeView(streakText: "0", isTodayComplete: false)
    }
    .padding(50)
    .background(Color.customDynamicBackgroundColor)
    .cornerRadius(30)
}
