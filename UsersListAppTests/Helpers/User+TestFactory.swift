//
//  User+TestFactory.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation
@testable import UsersListApp

extension User {
    static func makeList(count: Int) -> [User] {
        (0..<count).map { i in
            User(
                id: UUID().uuidString,
                firstName: "First\(i)",
                lastName: "Last\(i)",
                email: "user\(i)@test.com",
                phone: "000-\(i)",
                pictureURL: URL(string: "https://example.com/\(i).jpg") ?? URL(fileURLWithPath: ""),
                gender: "male",
                street: "\(i) Test St",
                city: "City",
                state: "State",
                registeredDate: .now
            )
        }
    }
}
