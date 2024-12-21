//
//  CustomColors.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

extension Color {
    static let customDynamicBackgroundColor = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            let greyValue = 0.1
            return UIColor(  // Dark mode
                red: greyValue,
                green: greyValue,
                blue: greyValue + 0.01,
                alpha: 1
            )
        } else {
            return UIColor.white // Light mode
        }
    })
    
    static let customTextColor = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.white // Dark mode
        } else {
            return UIColor.black // Light mode
        }
    })
    
    static let customButtonTextColor = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.black // Dark mode
        } else {
            return UIColor.white // Light mode
        }
    })
    
    static let customButtonBackgroundColor = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.white // Dark mode
        } else {
            return UIColor.black // Light mode
        }
    })
    
    static let customGreyColorBackground = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.systemGray5 // Dark mode
        } else {
            return UIColor.systemGray6 // Light mode
        }
    })
    
    static let customGreyColorTextStrong = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.secondaryLabel // Dark mode
        } else {
            return UIColor.secondaryLabel // Light mode
        }
    })
    
    static let customGreyColorTextWeak = Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.systemGray2 // Dark mode
        } else {
            return UIColor.systemGray2 // Light mode
        }
    })
}
