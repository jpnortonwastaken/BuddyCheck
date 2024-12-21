//
//  HapticManager.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/20/24.
//

import Foundation

import UIKit

enum HapticType {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
}

struct HapticManager {
    static func trigger(_ type: HapticType) {
        switch type {
        case .impact(let style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        case .notification(let feedbackType):
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(feedbackType)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
