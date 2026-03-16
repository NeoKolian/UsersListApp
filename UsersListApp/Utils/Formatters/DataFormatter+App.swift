//
//  DataFormatter.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

extension ISO8601DateFormatter {
   
    static let api: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    static func date(from string: String, fallback: Date = .now) -> Date {
        api.date(from: string) ?? fallback
    }
}
