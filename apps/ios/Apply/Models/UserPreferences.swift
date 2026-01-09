//
//  UserPreferences.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct UserPreferences: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let education: String?
    let preferredDomains: [String]?
    let preferredContract: String?
    let preferredLocation: String?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case education
        case preferredDomains = "preferred_domains"
        case preferredContract = "preferred_contract"
        case preferredLocation = "preferred_location"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
