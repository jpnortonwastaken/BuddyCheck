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
    
    /// Choose which haptic to fire on release. Or `nil` for none.
    var hapticType: HapticType? = .impact(.soft)
    
    /// The action to perform when the user *lifts their finger inside* the button.
    var action: () -> Void = { print("Button tapped!") }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            // This only fires if the user lifts inside the button
            // so we do the haptic right here.
            hapticType.map(HapticManager.trigger)
            action()
        }) {
            Text(text)
        }
        .buttonStyle(
            PressScaleButtonStyle(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                cornerRadius: cornerRadius,
                paddingHorizontal: paddingHorizontal,
                paddingVertical: paddingVertical,
                fullWidth: fullWidth,
                fontSize: fontSize,
                fontWeight: fontWeight
            )
        )
        // (Optional) Pre-warm haptics on appear to reduce first-tap lag
        .onAppear {
            preWarmHapticsIfNeeded()
        }
    }
    
    /// (Optional) Fires a quick haptic once so iOS caches the haptic engine,
    /// reducing lag on the very first real tap.
    private func preWarmHapticsIfNeeded() {
        // If you only want to do this once globally in your app,
        // you can move this logic to your AppDelegate or a top-level .onAppear
        // and store a boolean “didPrewarm” in @AppStorage or @State.
        hapticType.map(HapticManager.trigger)
    }
}

// MARK: - Button Style

/// A button style that does a manual withAnimation spring-scale on press/release.
fileprivate struct PressScaleButtonStyle: ButtonStyle {
    
    // MARK: - Style Properties
    
    var foregroundColor: Color
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var paddingHorizontal: CGFloat
    var paddingVertical: CGFloat
    var fullWidth: Bool
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    
    // MARK: - Body
    
    func makeBody(configuration: Configuration) -> some View {
        PressScaleButtonBody(
            configuration: configuration,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            paddingHorizontal: paddingHorizontal,
            paddingVertical: paddingVertical,
            fullWidth: fullWidth,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
    }
}

fileprivate struct PressScaleButtonBody: View {
    
    let configuration: ButtonStyle.Configuration
    
    // Style properties
    let foregroundColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let paddingHorizontal: CGFloat
    let paddingVertical: CGFloat
    let fullWidth: Bool
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    
    /// Tracks the visual pressed state in our style.
    @State private var isPressedState = false
    
    var body: some View {
        configuration.label
            .font(.system(size: fontSize, weight: fontWeight))
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            
            // Scale effect based on our local @State
            .scaleEffect(isPressedState ? 0.9 : 1.0)
            
            // Use the new iOS 17 onChange with two parameters:
            .onChange(of: configuration.isPressed, initial: false) { oldVal, newVal in
                // If newVal == true, user just pressed down
                // If newVal == false, user just released or canceled
                if newVal {
                    // Press down
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                        isPressedState = true
                    }
                } else {
                    // Release
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                        isPressedState = false
                    }
                    // We do NOT do haptic here because
                    // we handle it in the Button(action: ...) code
                }
            }
    }
}

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
