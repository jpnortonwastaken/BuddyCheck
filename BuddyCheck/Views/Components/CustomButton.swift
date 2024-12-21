//
//  CustomButton.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/20/24.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    var text: String = "Button"
    var foregroundColor: Color = Color.customButtonTextColor
    var backgroundColor: Color = Color.customButtonBackgroundColor
    var cornerRadius: CGFloat = .infinity
    var paddingHorizontal: CGFloat = 28
    var paddingVertical: CGFloat = 14
    var fullWidth: Bool = false
    var fontSize: CGFloat = 17
    var fontWeight: Font.Weight = .semibold
    var action: () -> Void = { print("Button tapped!") }
    
    @State private var isPressed = false
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: fontWeight))
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            //.opacity(isPressed ? 0.4 : 1.0)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .onTapGesture {
                HapticManager.trigger(.impact(.soft))
                action()
            }
            .pressEvents {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                    isPressed = true
                }
            } onRelease: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                    isPressed = false
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
                    .onChanged({_ in
                        onPress()
                    })
                    .onEnded({_ in
                        onRelease()
                    })
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPress(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}

#Preview {
    CustomButton()
}

//CustomButton(
//    text: <#T##String#>,
//    foregroundColor: <#T##Color#>,
//    backgroundColor: <#T##Color#>,
//    cornerRadius: <#T##CGFloat#>,
//    paddingHorizontal: <#T##CGFloat#>,
//    paddingVertical: <#T##CGFloat#>,
//    fullWidth: <#T##Bool#>,
//    action: <#T##() -> Void#>
//)
