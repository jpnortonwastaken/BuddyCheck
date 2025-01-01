//
//  HapticManager.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/20/24.
//

import Foundation
import UIKit

// MARK: - Haptic Type

/// Represents the types of haptic feedback available.
enum HapticType {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
}

// MARK: - Haptic Manager

/// A utility to manage haptic feedback throughout the app.
struct HapticManager {
    
    /// Triggers the specified haptic feedback.
    /// - Parameter type: The type of haptic feedback to generate.
    static func trigger(_ type: HapticType) {
        switch type {
        case .impact(let style):
            triggerImpactFeedback(style)
        case .notification(let feedbackType):
            triggerNotificationFeedback(feedbackType)
        case .selection:
            triggerSelectionFeedback()
        }
    }
    
    // MARK: - Private Helpers
    
    /// Generates impact feedback with the given style.
    /// - Parameter style: The impact style to use.
    private static func triggerImpactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare() // Ensures responsiveness
        generator.impactOccurred()
    }
    
    /// Generates notification feedback with the given type.
    /// - Parameter type: The notification feedback type to use.
    private static func triggerNotificationFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    /// Generates selection feedback.
    private static func triggerSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

// MARK: - Example Usage
// HapticManager.trigger(.impact(.medium))
// HapticManager.trigger(.notification(.success))
// HapticManager.trigger(.selection)
