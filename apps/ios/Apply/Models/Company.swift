//
//  Company.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct Company: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String?
    let website: String?
    let logo: String?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case website
        case logo
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
