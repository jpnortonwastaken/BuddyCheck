//
//  LoadingView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/29/24.
//

import SwiftUI

struct LoadingView: View {
    
    // MARK: - Properties (1)
    
    /// The alignment for the loading indicator.
    let alignment: VerticalAlignment
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if alignment == .top {
                loadingIndicator
                Spacer()
            } else if alignment == .center {
                Spacer()
                loadingIndicator
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customDynamicBackgroundColor)
    }
    
    // MARK: - Subviews (1)
    
    /// Reusable loading indicator view.
    private var loadingIndicator: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color.customGreyColorTextStrong))
            .scaleEffect(1.5)
    }
}

// MARK: - Preview

#Preview {
    LoadingView(alignment: .center)
    // LoadingView(alignment: .top)
}
