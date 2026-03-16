//
//  UserResponseDTO.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

struct UserResponseDTO: Decodable {
    
    let results: [UserDTO]
}

struct UserDTO: Decodable {
    let name: NameDTO
    let dateOfBirth: DobDTO
    let gender: String
    let email: String
    let phone: String
    let location: LocationDTO
    let picture: PictureDTO
    let registered: RegisteredDTO
    
    struct NameDTO: Decodable {
        let first: String
        let last: String
    }

    struct DobDTO: Decodable {
        let date: String
    }
    
    struct LocationDTO: Decodable {
        let street: StreetDTO
        let city: String
        let state: String
    }
    struct StreetDTO: Decodable {
        let name: String
        let number: Int
    }
    
    struct PictureDTO: Decodable {
        let large: String
        let thumbnail: String
    }
    
    struct RegisteredDTO: Decodable {
        let date: String
    }
}
