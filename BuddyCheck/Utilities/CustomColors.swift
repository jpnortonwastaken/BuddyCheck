//
//  CustomDynamicBackground.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

extension Color {
    static let customDynamicBackground = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            let greyValue = 0.1
            return UIColor(red: greyValue, green: greyValue, blue: greyValue + 0.01, alpha: 1)
        } else {
            return UIColor.white
        }
    })
}
