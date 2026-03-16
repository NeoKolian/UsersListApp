//
//  UserMapper.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

struct UserMapper {
    static func map(_ dto: UserDTO) -> User? {
        guard let pictureURL = URL(string: dto.picture.large) else { return nil }

        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: dto.registered.date) ?? Date()
        
        return User(
            id:             dto.email,
            firstName:      dto.name.first,
            lastName:       dto.name.last,
            email:          dto.email,
            phone:          dto.phone,
            pictureURL:     pictureURL,
            gender:         dto.gender,
            street:         "\(dto.location.street.number) \(dto.location.street.name)",
            city:           dto.location.city,
            state:          dto.location.state,
            registeredDate: date
        )
    }
}
