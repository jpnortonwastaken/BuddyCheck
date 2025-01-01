//
//  CustomButton.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/20/24.
//

import SwiftUI

struct CustomButton: View {
    
    // MARK: - Properties
    
    var text: String = "Button"
    var foregroundColor: Color = Color.customButtonTextColor
    var backgroundColor: Color = Color.customButtonBackgroundColor
    var cornerRadius: CGFloat = .infinity
    var paddingHorizontal: CGFloat = 28
    var paddingVertical: CGFloat = 14
    var fullWidth: Bool = false
    var fontSize: CGFloat = 17
    var fontWeight: Font.Weight = .semibold
    var hapticType: HapticType? = .impact(.soft)
    var action: () -> Void = { print("Button tapped!") }
    
    @State private var isPressed = false
    @State private var hasTriggeredHaptic = false
    
    // MARK: - Body
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: fontWeight))
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .pressEvents {
                handlePress()
            } onRelease: {
                handleRelease()
            }
    }
    
    // MARK: - Helper Methods
    
    private func handlePress() {
        if !hasTriggeredHaptic {
            hapticType.map(HapticManager.trigger)
            hasTriggeredHaptic = true
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
            isPressed = true
        }
    }
    
    private func handleRelease() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
            isPressed = false
        }
        hasTriggeredHaptic = false
        action()
    }
}

// MARK: - AsyncCustomButton Extension

struct AsyncCustomButton: View {
    
    // MARK: - Properties
    
    var text: String = "Button"
    var loadingText: String = "Loading..."
    var foregroundColor: Color = Color.customButtonTextColor
    var backgroundColor: Color = Color.customButtonBackgroundColor
    var cornerRadius: CGFloat = .infinity
    var paddingHorizontal: CGFloat = 28
    var paddingVertical: CGFloat = 14
    var fullWidth: Bool = false
    var fontSize: CGFloat = 17
    var fontWeight: Font.Weight = .semibold
    var hapticType: HapticType? = .impact(.soft)
    var asyncAction: () async -> Void
    
    @State private var isLoading = false
    @State private var isPressed = false
    @State private var hasTriggeredHaptic = false
    
    // MARK: - Body
    
    var body: some View {
        Text(isLoading ? loadingText : text)
            .font(.system(size: fontSize, weight: fontWeight))
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .pressEvents {
                handlePress()
            } onRelease: {
                handleRelease()
            }
            .animation(.easeInOut, value: isLoading)
    }
    
    // MARK: - Helper Methods
    
    private func handlePress() {
        if !hasTriggeredHaptic {
            hapticType.map(HapticManager.trigger)
            hasTriggeredHaptic = true
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
            isPressed = true
        }
    }
    
    private func handleRelease() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
            isPressed = false
        }
        hasTriggeredHaptic = false
        
        // Trigger async action
        Task {
            isLoading = true
            await asyncAction()
            isLoading = false
        }
    }
}

// MARK: - Extensions

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onPress()
                    }
                    .onEnded { _ in
                        onRelease()
                    }
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(ButtonPress(onPress: onPress, onRelease: onRelease))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        // Synchronous Button Example
        CustomButton(
            text: "Submit",
            backgroundColor: Color.blue,
            fullWidth: true,
            action: {
                print("Sync action completed")
            }
        )
        
        // Asynchronous Button Example
        AsyncCustomButton(
            text: "Check In",
            asyncAction: {
                try? await Task.sleep(nanoseconds: 2_000_000_000) // Simulate async work
                print("Async action completed")
            }
        )
    }
    .padding(.horizontal)
}
