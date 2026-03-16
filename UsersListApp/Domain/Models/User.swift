//
//  User.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let pictureURL: URL
    let gender: String
    let street: String
    let city: String
    let state: String
    let registeredDate: Date
    
    var fullName: String { "\(firstName) \(lastName)" }
}
