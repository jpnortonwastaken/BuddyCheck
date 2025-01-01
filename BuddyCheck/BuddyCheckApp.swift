//
//  BuddyCheckApp.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/17/24.
//

import GoogleSignIn
import SwiftUI

@main
struct BuddyCheckApp: App {
    
    // MARK: - Properties (1)
    
    /// Create a shared instance of the MainViewModel to manage app-wide state
    @StateObject private var viewModel = MainViewModel()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            EntryView() // Inject the ViewModel
                .environmentObject(viewModel)
                .onOpenURL { url in
                    // Handle incoming URLs, such as Google Sign-In callbacks
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    // Restore the previous user session, if available
                    viewModel.restorePreviousSignIn()
                }
        }
    }
}
