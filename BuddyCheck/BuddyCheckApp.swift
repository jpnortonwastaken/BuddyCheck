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
    @StateObject var viewModel = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            ProtectorView(viewModel: viewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    viewModel.restorePreviousSignIn()
                }
        }
    }
}
