//
//  MainViewModel+Auth.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/31/24.
//

import SwiftUI
import GoogleSignIn
import PostgREST

extension MainViewModel {
    
    // MARK: - User Fetch/Create
    
    /// Fetches a user by email from Supabase. Throws an error if not found.
    func fetchUserFromSupabase(email: String) async throws -> User {
        do {
            let response = try await supabase
                .from("users")
                .select()
                .eq("email", value: email)
                .single()
                .execute()

            let user = try JSONDecoder().decode(User.self, from: response.data)
            return user
        } catch let error as PostgrestError where error.code == "PGRST116" {
            // "No Rows Returned" error
            throw NSError(
                domain: "UserNotFoundError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "No user found with the given email."]
            )
        } catch {
            throw error
        }
    }
    
    /// Creates a new user in Supabase.
    func addUserToSupabase(email: String, name: String?, photoURL: URL?) async throws -> User {
        let newUser = User(
            id: UUID(),
            name: name ?? "Unknown",
            email: email,
            photo_url: photoURL,
            created_at: ISO8601DateFormatter().string(from: Date())
        )

        do {
            _ = try await supabase
                .from("users")
                .insert(newUser)
                .execute()
            
            return newUser
        } catch {
            throw error
        }
    }

    /// Either fetches an existing user or creates a new one if none is found.
    func fetchOrCreateUser(email: String, name: String?, photoURL: URL?) async throws -> User {
        do {
            // Attempt to fetch the user
            return try await fetchUserFromSupabase(email: email)
        } catch let fetchError as NSError where fetchError.domain == "UserNotFoundError" {
            // If not found, create
            return try await addUserToSupabase(email: email, name: name, photoURL: photoURL)
        } catch {
            throw error
        }
    }
    
    // MARK: - Sign-In Flow
    
    /// Restores the previous sign-in session if available.
    func restorePreviousSignIn() {
        isLoadingUser = true
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            Task {
                defer { self.isLoadingUser = false }
                
                guard let user = user else {
                    print("ℹ️ No previous user signed in.")
                    return
                }
                
                do {
                    self.currentUser = try await self.fetchOrCreateUser(
                        email: user.profile?.email ?? "",
                        name: user.profile?.name,
                        photoURL: user.profile?.imageURL(withDimension: 100)
                    )
                    print("✅ Successfully restored sign-in for: \(self.currentUser?.name ?? "Unknown")")
                } catch {
                    print("❌ Error restoring previous sign-in: \(error)")
                }
            }
        }
    }
    
    /// Signs in with Google, presenting the Google sign-in flow on the provided view controller.
    func signInWithGoogle(presenting viewController: UIViewController) {
        isLoadingUser = true
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            Task {
                defer { self.isLoadingUser = false }
                
                guard let result = result else {
                    print("❌ Error during Google sign-in: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    self.currentUser = try await self.fetchOrCreateUser(
                        email: result.user.profile?.email ?? "",
                        name: result.user.profile?.name,
                        photoURL: result.user.profile?.imageURL(withDimension: 100)
                    )
                    print("✅ Successfully signed in as: \(self.currentUser?.name ?? "Unknown")")
                } catch {
                    print("❌ Error during Google sign-in: \(error)")
                }
            }
        }
    }
    
    /// Logs out the current user and clears local state.
    func logOutUser() {
        GIDSignIn.sharedInstance.signOut()
        currentUser = nil
        projects = []
    }
}
