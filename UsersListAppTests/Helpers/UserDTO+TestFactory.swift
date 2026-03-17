//
//  UserDTO+TestFactory.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 17.03.2026.
//

import Foundation
@testable import UsersListApp

extension UserDTO {
    static func make(
        email: String = "user@test.com",
        firstName: String = "John",
        lastName: String = "Doe"
    ) -> UserDTO {
        UserDTO(
            name: .init(first: firstName, last: lastName),
            dob: .init(date: "1990-01-01T00:00:00.000Z"),
            gender: "male",
            email: email,
            phone: "123-456",
            location: .init(
                street: .init(name: "Main St", number: 42),
                city: "London",
                state: "England"
            ),
            picture: .init(
                large: "https://example.com/photo.jpg",
                thumbnail: "https://example.com/thumb.jpg"
            ),
            registered: .init(date: "2020-06-15T10:30:00.000Z"),
            id: .init(name: "SSN", value: "123")
        )
    }
}
