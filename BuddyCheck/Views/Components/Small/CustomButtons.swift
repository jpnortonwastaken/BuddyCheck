//
//  CustomButton.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/20/24.
//

import SwiftUI

struct CustomButton: View {
    
    // MARK: - Properties (13)
    
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
            //.animation(.easeInOut(duration: 0.2), value: text) // smooth text transition
            .pressEvents {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                    isPressed = true
                }
            } onRelease: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                    isPressed = false
                }
                if !hasTriggeredHaptic {
                    hapticType.map(HapticManager.trigger)
                    hasTriggeredHaptic = true // Ensure haptic triggers only once
                }
                hasTriggeredHaptic = false // Reset haptic flag for next press
                action()
            }
    }
}

// MARK: - Extensions (2)

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
    Group {
        CustomButton()
        
        CustomButton(
            text: "Other Button",
            backgroundColor: Color.blue,
            fullWidth: true
        )
        .padding()
    }
}
