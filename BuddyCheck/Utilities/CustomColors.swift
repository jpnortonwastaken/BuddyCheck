//
//  CustomColors.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

extension Color {
    init(lightMode: UIColor, darkMode: UIColor) {
        self.init(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? darkMode : lightMode
        })
    }
}

extension Color {
    static let customDynamicBackgroundColor = Color(
        lightMode: UIColor.white,
        darkMode: UIColor(
            red: 0.1,
            green: 0.1,
            blue: 0.11,
            alpha: 1
        )
    )
    
    static let customTextColor = Color(
        lightMode: UIColor.black,
        darkMode: UIColor.white
    )
    
    static let customButtonTextColor = Color(
        lightMode: UIColor.white,
        darkMode: UIColor.black
    )
    
    static let customButtonBackgroundColor = Color(
        lightMode: UIColor.black,
        darkMode: UIColor.white
    )
    
    static let customGreyColorBackground = Color(
        lightMode: UIColor.systemGray6,
        darkMode: UIColor.systemGray5
    )
    
    static let customGreyColorTextStrong = Color(
        lightMode: UIColor.secondaryLabel,
        darkMode: UIColor.secondaryLabel
    )
    
    static let customGreyColorTextWeak = Color(
        lightMode: UIColor.systemGray2,
        darkMode: UIColor.systemGray2
    )
    
    static let customGreyColorSuperWeak = Color(
        lightMode: UIColor.systemGray4,
        darkMode: UIColor.systemGray3
    )
    
    static let customGreenQuaternary = Color(
        UIColor.systemGreen.withAlphaComponent(0.2)
    )
    
    static let customRedQuaternary = Color(
        UIColor.systemRed.withAlphaComponent(0.2)
    )
}
