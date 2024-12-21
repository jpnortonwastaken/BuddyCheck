//
//  ProjectView.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import SwiftUI

struct ProjectView: View {
    let project: Project
    let hasCheckedInToday: ([Checkin]) -> Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text(project.name)
                    .font(.title2)
                    .bold()
                
                if let desc = project.description {
                    Text(desc)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color.customGreyColorTextStrong)
                }
            }
            
            VStack(spacing: 10) {
                ForEach(chunkArray(Array(project.collaborators), into: 3), id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row) { collaborator in
                            HStack {
                                ProfilePictureView(user: collaborator.user, size: 36)
                                
                                Spacer()
                                
                                if hasCheckedInToday(collaborator.checkins) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(Color.green)
                                        .padding(.trailing, 4)
                                } else {
                                    Image(systemName: "x.circle.fill")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(Color.red)
                                        .padding(.trailing, 4)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, minHeight: 40) // Equal width and consistent height
                            .background(
                                hasCheckedInToday(collaborator.checkins) ? Color.green.quaternary : Color.red.quaternary
                            )
                            .cornerRadius(.infinity)
                        }
                    }
                }
            }
            
            CustomButton(
                text: "Check In",
                cornerRadius: 20,
                paddingVertical: 16,
                fullWidth: true,
                action: {
                    //
                }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.customGreyColorBackground)
        .cornerRadius(20)
    }
    
    // Helper function to chunk array
    private func chunkArray<T>(_ array: [T], into size: Int) -> [[T]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0..<min($0 + size, array.count)])
        }
    }
}

#Preview {
    ProjectView(project: Project.mockProject1, hasCheckedInToday: MockFunctions.mockHasCheckedInToday(_:))
        .padding(16)
}
