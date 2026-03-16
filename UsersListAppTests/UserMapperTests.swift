//
//  UserMapperTests.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import XCTest
@testable import UsersListApp

final class UserMapperTests: XCTestCase {

    // MARK: - Invalid Picture URL (guard)

    func testMapInvalidPictureURL_ReturnsNil() {
        let dto = makeValidDTO(pictureURL: "")

        let user = UserMapper.map(dto)

        XCTAssertNil(user)
    }

    func testMapMalformedPictureURL_ReturnsNil() {
        let dto = makeValidDTO(pictureURL: "ht tp://invalid url")

        let user = UserMapper.map(dto)

        XCTAssertNil(user)
    }

    // MARK: - Date Parsing

    func testMapValidDTO_ParsesISO8601Date() {
        let dto = makeValidDTO(registeredDate: "2020-06-15T10:30:00.000Z")

        let user = UserMapper.map(dto)

        let expected = ISO8601DateFormatter.api.date(from: "2020-06-15T10:30:00.000Z")
        XCTAssertEqual(user?.registeredDate, expected)
    }

    func testMapInvalidDate_UsesFallback() {
        let before = Date.now
        let dto = makeValidDTO(registeredDate: "not-a-date")

        let user = UserMapper.map(dto)
        let after = Date.now

        XCTAssertNotNil(user)
        if let date = user?.registeredDate {
            XCTAssertGreaterThanOrEqual(date, before)
            XCTAssertLessThanOrEqual(date, after)
        }
    }

    // MARK: - Valid DTO (field mapping)

    func testMapValidDTO_ReturnsUser() {
        let dto = makeValidDTO()

        let user = UserMapper.map(dto)

        XCTAssertNotNil(user)
    }

    func testMapValidDTO_MapsNameCorrectly() {
        let dto = makeValidDTO(firstName: "Maria", lastName: "Garcia")

        let user = UserMapper.map(dto)

        XCTAssertEqual(user?.firstName, "Maria")
        XCTAssertEqual(user?.lastName, "Garcia")
    }

    func testMapValidDTO_GeneratesUUIDAsID() {
        let dto = makeValidDTO()

        let user = UserMapper.map(dto)

        XCTAssertNotNil(user?.id)
        XCTAssertNotNil(UUID(uuidString: user?.id ?? ""))
    }

    func testMapValidDTO_GeneratesUniqueIDs() {
        let dto = makeValidDTO()

        let user1 = UserMapper.map(dto)
        let user2 = UserMapper.map(dto)

        XCTAssertNotEqual(user1?.id, user2?.id)
    }

    func testMapValidDTO_MapsEmailCorrectly() {
        let dto = makeValidDTO(email: "test@mail.com")

        let user = UserMapper.map(dto)

        XCTAssertEqual(user?.email, "test@mail.com")
    }

    func testMapValidDTO_MapsPhoneCorrectly() {
        let dto = makeValidDTO(phone: "0161 818 9583")

        let user = UserMapper.map(dto)

        XCTAssertEqual(user?.phone, "0161 818 9583")
    }

    func testMapValidDTO_MapsGenderCorrectly() {
        let dto = makeValidDTO(gender: "female")

        let user = UserMapper.map(dto)

        XCTAssertEqual(user?.gender, "female")
    }

    func testMapValidDTO_MapsPictureURL() {
        let dto = makeValidDTO(pictureURL: "https://example.com/avatar.jpg")

        let user = UserMapper.map(dto)

        XCTAssertEqual(user?.pictureURL.absoluteString, "https://example.com/avatar.jpg")
    }

    func testMapValidDTO_MapsStreetCorrectly() {
        let dto = makeValidDTO(streetName: "Baker St", streetNumber: 221)

        let user = UserMapper.map(dto)

        XCTAssertEqual(user?.street, "221 Baker St")
    }

    func testMapValidDTO_MapsCityAndState() {
        let dto = makeValidDTO(city: "Manchester", state: "Greater Manchester")

        let user = UserMapper.map(dto)

        XCTAssertEqual(user?.city, "Manchester")
        XCTAssertEqual(user?.state, "Greater Manchester")
    }

    // MARK: - Helpers

    private func makeValidDTO(
        firstName: String = "John",
        lastName: String = "Doe",
        email: String = "john@example.com",
        phone: String = "123-456",
        gender: String = "male",
        pictureURL: String = "https://example.com/photo.jpg",
        streetName: String = "Main St",
        streetNumber: Int = 42,
        city: String = "London",
        state: String = "England",
        registeredDate: String = "2020-06-15T10:30:00.000Z"
    ) -> UserDTO {
        UserDTO(
            name: .init(first: firstName, last: lastName),
            dob: .init(date: "1990-01-01T00:00:00.000Z"),
            gender: gender,
            email: email,
            phone: phone,
            location: .init(
                street: .init(name: streetName, number: streetNumber),
                city: city,
                state: state
            ),
            picture: .init(large: pictureURL, thumbnail: pictureURL),
            registered: .init(date: registeredDate),
            id: .init(name: "SSN", value: "123")
        )
    }
}
