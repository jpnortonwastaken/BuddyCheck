//
//  HapticTesterView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/20/24.
//

import SwiftUI

struct HapticTesterView: View {
    var body: some View {
        ZStack {
            Color.customDynamicBackgroundColor
                .ignoresSafeArea()
            VStack(spacing: 16) {
                // Impact Feedback Buttons
                Group {
                    Text("Impact Feedback").font(.headline)
                    
                    Button(action: {
                        HapticManager.trigger(.impact(.light))
                    }) {
                        Text("Light Impact")
                            .buttonStyle()
                    }
                    
                    Button(action: {
                        HapticManager.trigger(.impact(.medium))
                    }) {
                        Text("Medium Impact")
                            .buttonStyle()
                    }
                    
                    Button(action: {
                        HapticManager.trigger(.impact(.heavy))
                    }) {
                        Text("Heavy Impact")
                            .buttonStyle()
                    }
                    
                    Button(action: {
                        HapticManager.trigger(.impact(.rigid))
                    }) {
                        Text("Rigid Impact")
                            .buttonStyle()
                    }
                    
                    Button(action: {
                        HapticManager.trigger(.impact(.soft))
                    }) {
                        Text("Soft Impact")
                            .buttonStyle()
                    }
                }
                
                Divider()
                
                // Notification Feedback Buttons
                Group {
                    Text("Notification Feedback").font(.headline)
                    
                    Button(action: {
                        HapticManager.trigger(.notification(.success))
                    }) {
                        Text("Success Notification")
                            .buttonStyle()
                    }
                    
                    Button(action: {
                        HapticManager.trigger(.notification(.warning))
                    }) {
                        Text("Warning Notification")
                            .buttonStyle()
                    }
                    
                    Button(action: {
                        HapticManager.trigger(.notification(.error))
                    }) {
                        Text("Error Notification")
                            .buttonStyle()
                    }
                }
                
                Divider()
                
                // Selection Feedback Button
                Group {
                    Text("Selection Feedback").font(.headline)
                    
                    Button(action: {
                        HapticManager.trigger(.selection)
                    }) {
                        Text("Selection Feedback")
                            .buttonStyle()
                    }
                }
            }
            .padding()
        }
    }
}

extension View {
    func buttonStyle() -> some View {
        self
            .bold()
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.customButtonBackgroundColor)
            .foregroundColor(Color.customButtonTextColor)
            .cornerRadius(10)
    }
}

#Preview {
    HapticTesterView()
}
