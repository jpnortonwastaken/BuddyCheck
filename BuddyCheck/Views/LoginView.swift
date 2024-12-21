//
//  LoginView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/17/24.
//

import SwiftUI
import Supabase

struct LoginView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Image("AppIconLarge")
                .resizable()
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 38))
            
            Spacer()
            
            // Top Text
            VStack(alignment: .leading, spacing: 8) {
                Text("BuddyCheck")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color.gray)
                
                Text("Welcome. Your daily check starts here.")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Continue with Google Button
            Button(action: {
                // [Action will go here...]
            }) {
                Text("Continue with Google")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(40)
            }
            
            // Terms and Conditions Text
            Text("By clicking “Continue with Google”, you acknowledge that you have read and understood, and agree to BuddyCheck's Terms & Conditions and Privacy Policy.")
                .font(.system(size: 8))
                .foregroundColor(Color.gray)
                .padding(.top, 8)
            
            Spacer()
        }
        .ignoresSafeArea()
        .padding(.horizontal, 32)
        .background(Color.white)
    }
}

#Preview {
    LoginView()
}
