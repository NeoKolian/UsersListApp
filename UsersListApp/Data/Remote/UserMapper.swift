//
//  UserMapper.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

struct UserMapper {
    static func map(_ dto: UserDTO) -> User {
        
        let pictureURL = URL(string: dto.picture.large)
        let date = ISO8601DateFormatter.date(from: dto.registered.date)
        
        return User(
            id:             UUID().uuidString,
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
