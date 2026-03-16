//
//  UserListView+Preview.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI

extension User {
    static let sample = User(
        id:             UUID().uuidString,
        firstName:      "John",
        lastName:       "Doe",
        email:          "john.doe@example.com",
        phone:          "0161 818 9583",
        pictureURL:     URL(string: "https://randomuser.me/api/portraits/men/1.jpg") ?? URL(fileURLWithPath: ""),
        gender:         "male",
        street:         "123 Main St",
        city:           "Manchester",
        state:          "Greater Manchester",
        registeredDate: Date()
    )

    static let sampleList: [User] = (1...10).map { i in
        User(
            id:             UUID().uuidString,
            firstName:      ["John", "Maria", "Alex", "Sarah", "Mike"][i % 5],
            lastName:       ["Smith", "Garcia", "Johnson", "Brown", "Davis"][i % 5],
            email:          "user\(i)@example.com",
            phone:          "0161 818 \(1000 + i)",
            pictureURL:     URL(string: "https://randomuser.me/api/portraits/men/\(i).jpg") ?? URL(fileURLWithPath: ""),
            gender:         i % 2 == 0 ? "male" : "female",
            street:         "\(i * 10) Sample Street",
            city:           "London",
            state:          "England",
            registeredDate: Date()
        )
    }
}
