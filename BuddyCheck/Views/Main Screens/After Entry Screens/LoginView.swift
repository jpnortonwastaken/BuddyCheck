//
//  LoginView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/17/24.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    
    // MARK: - Properties (1)
    
    /// The shared MainViewModel instance.
    @EnvironmentObject var viewModel: MainViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            // App Icon
            appIcon
            
            Spacer()
            
            // Welcome Text
            welcomeText
            
            // Continue with Google Button
            googleSignInButton
            
            // Terms and Conditions Text
            termsAndConditionsText
            
            Spacer()
        }
        .ignoresSafeArea()
        .padding(.horizontal, 32)
        .background(Color.customDynamicBackgroundColor)
    }
    
    // MARK: - Subviews (4)
    
    private var appIcon: some View {
        Image("AppIconLarge")
            .resizable()
            .frame(width: 180, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 38))
    }
    
    private var welcomeText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("BuddyCheck")
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(Color.customGreyColorTextWeak)
            
            Text("Welcome. Your daily check starts here.")
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(Color.customTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var googleSignInButton: some View {
        CustomButton(
            text: "Continue with Google",
            paddingHorizontal: 16,
            paddingVertical: 16,
            fullWidth: true,
            fontSize: 18,
            action: handleGoogleSignInButton
        )
    }
    
    private var termsAndConditionsText: some View {
        Text("""
            By clicking “Continue with Google”, you acknowledge that you have read and understood, \
            and agree to BuddyCheck's Terms & Conditions and Privacy Policy.
            """)
            .font(.system(size: 8))
            .foregroundColor(Color.customGreyColorTextStrong)
            .padding(.top, 8)
    }
    
    // MARK: - Methods (1)
    
    /// Handles the Google Sign-In button action.
    private func handleGoogleSignInButton() {
        if let rootViewController = getRootViewController() {
            viewModel.signInWithGoogle(presenting: rootViewController)
        }
    }
}

// MARK: - Utility Functions (2)

private func getRootViewController() -> UIViewController? {
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = scene.windows.first?.rootViewController else {
        return nil
    }
    return getVisibleViewController(from: rootViewController)
}

private func getVisibleViewController(from vc: UIViewController) -> UIViewController {
    if let nav = vc as? UINavigationController {
        return getVisibleViewController(from: nav.visibleViewController!)
    }
    if let tab = vc as? UITabBarController {
        return getVisibleViewController(from: tab.selectedViewController!)
    }
    if let presented = vc.presentedViewController {
        return getVisibleViewController(from: presented)
    }
    return vc
}

// MARK: - Preview

#Preview {
    let testViewModel = MainViewModel()
    testViewModel.currentUser = nil // Set to User.mockAlice to test a logged-in state
    
    return LoginView()
            .environmentObject(testViewModel)
}
