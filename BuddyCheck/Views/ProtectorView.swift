//
//  ContentView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/18/24.
//

import SwiftUI

struct ProtectorView: View {
    @Binding var user: User?
    
    var body: some View {
        if user != nil {
            MainView(user: self.$user)
        } else {
            LoginView(user: self.$user)
        }
    }
}
