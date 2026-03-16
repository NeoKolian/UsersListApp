//
//  UserRepository.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers(page: Int) async throws -> [User]
    func getSavedUsers() -> [User]
    func deleteUser(id: String)
    func isDeleted(id: String) -> Bool
}

struct UserRepository: UserRepositoryProtocol {
    
    func fetchUsers(page: Int) async throws -> [User] {
        []
    }
    
    func getSavedUsers() -> [User] {
        []
    }
    
    func deleteUser(id: String) {
        
    }
    
    func isDeleted(id: String) -> Bool {
        true
    }
}
