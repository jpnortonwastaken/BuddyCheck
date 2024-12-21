//
//  LoginView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/17/24.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            // App Icon
            Image("AppIconLarge")
                .resizable()
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 38))
            
            Spacer()
            
            // Top Text
            VStack(alignment: .leading, spacing: 8) {
                Text("BuddyCheck")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color.customGreyColorTextWeak)
                
                Text("Welcome. Your daily check starts here.")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color.customTextColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Continue with Google Button
            CustomButton(
                text: "Continue with Google",
                paddingHorizontal: 16,
                paddingVertical: 16,
                fullWidth: true,
                fontSize: 18,
                action: {
                    handleGoogleSignInButton()
                }
            )
            
            // Terms and Conditions Text
            Text("By clicking “Continue with Google”, you acknowledge that you have read and understood, and agree to BuddyCheck's Terms & Conditions and Privacy Policy.")
                .font(.system(size: 8))
                .foregroundColor(Color.gray)
                .padding(.top, 8)
            
            Spacer()
        }
        .ignoresSafeArea()
        .padding(.horizontal, 32)
        .background(Color.customDynamicBackgroundColor)
    }
    
    func handleGoogleSignInButton() {
        if let rootViewController = getRootViewController() {
            viewModel.signInWithGoogle(presenting: rootViewController)
        }
    }
}

func getRootViewController() -> UIViewController? {
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

#Preview {
    let vm = MainViewModel()
    vm.currentUser = User.mockAlice
    return LoginView(viewModel: vm)
}
