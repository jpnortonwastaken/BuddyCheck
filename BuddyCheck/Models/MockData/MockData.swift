//
//  MockData.swift
//  BuddyCheck
//
//  Created by JP Norton on 12/19/24.
//

import Foundation

// MARK: - User Mocks
extension User {
    static var mockAlice: User {
        User(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            name: "Alice Johnson",
            email: "alice.johnson@example.com",
            photo_url: URL(string: "https://cdn.pixabay.com/photo/2020/12/27/20/24/smile-5865208_640.png"),
            created_at: ISO8601DateFormatter().string(from: Date())
        )
    }
    
    static var mockBob: User {
        User(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            name: "Bob Smith",
            email: "bob.smith@example.com",
            photo_url: URL(string: "https://m.media-amazon.com/images/I/51O+dg78QQL._AC_UF894,1000_QL80_.jpg"),
            created_at: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-86400))
        )
    }
    
    static var mockCharlie: User {
        User(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            name: "Charlie Brown",
            email: "charlie.brown@example.com",
            photo_url: URL(string: "https://ih1.redbubble.net/image.756800590.1876/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.u2.jpg"),
            created_at: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-172800))
        )
    }
}

// MARK: - Checkin Mocks
extension Checkin {
    static var mockCheckinAliceProject2: Checkin {
        Checkin(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            project_id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, // Project 1
            user_id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, // Alice
            created_at: ISO8601DateFormatter().string(from: Date())
        )
    }
    
    static var mockCheckinBobProject1: Checkin {
        Checkin(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            project_id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, // Project 2
            user_id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, // Bob
            created_at: ISO8601DateFormatter().string(from: Date())
        )
    }
    
    static var UNUSEDmockCheckinCharlieProject1: Checkin {
        Checkin(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            project_id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, // Project 1
            user_id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, // Charlie
            created_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}

// MARK: - Collaborator Mocks
extension Collaborator {
    static var mockCollaboratorBobProject1: Collaborator {
        Collaborator(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            project_id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, // Project 1
            user: User.mockBob,
            role: Collaborator.Role.collaborator,
            joined_at: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-86400)),
            checkins: [Checkin.mockCheckinBobProject1]
        )
    }
    
    static var mockCollaboratorAliceProject2: Collaborator {
        Collaborator(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            project_id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, // Project 2
            user: User.mockAlice,
            role: Collaborator.Role.collaborator,
            joined_at: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-172800)),
            checkins: [Checkin.mockCheckinAliceProject2]
        )
    }
    
    static var mockCollaboratorCharlieProject1: Collaborator {
        Collaborator(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            project_id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, // Project 1
            user: User.mockCharlie,
            role: Collaborator.Role.collaborator,
            joined_at: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-432000)),
            checkins: []
        )
    }
}

// MARK: - Project Mocks
extension Project {
    static var mockProject1: Project {
        Project(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            title: "Project 1",
            description: "A sample project for previewing. This is the description to Project 1.",
            created_by: User.mockBob,
            created_at: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-604800)),
            collaborators: [Collaborator.mockCollaboratorBobProject1, Collaborator.mockCollaboratorCharlieProject1]
        )
    }
    
    static var mockProject2: Project {
        Project(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            title: "Project 2",
            description: "Another sample project with a different focus. This is the description to Project 2.",
            created_by: User.mockAlice,
            created_at: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-1209600)),
            collaborators: [Collaborator.mockCollaboratorAliceProject2]
        )
    }
}

// MARK: - MockHelpers
struct MockFunctions {
    static func mockCheckIn(project: Project) {
        print("Mock Checked in, update supabase")
    }
    
    static func mockUnCheckIn(project: Project) {
        print("Mock Un Checked in, update supabase")
    }
    
    static let mockGetCurrentUserID: () -> UUID? = {
        // Replace this with a consistent mock UUID for testing
        UUID(uuidString: "12345678-1234-5678-1234-567812345678")
    }
    
}
