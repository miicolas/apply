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
    let preferredContract: String?
    let preferredLocation: String?
    let createdAt: Date?
    let updatedAt: Date?
}

enum LocationType: String, Codable, CaseIterable {
    case remote = "remote"
    case onsite = "onsite"
    case hybrid = "hybrid"

    var displayName: String {
        switch self {
        case .remote: return "Télétravail"
        case .onsite: return "Sur site"
        case .hybrid: return "Hybride"
        }
    }
}
