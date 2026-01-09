//
//  UserPreferencesDTO.swift
//  Apply
//

import Foundation

struct CreateUserPreferencesRequest: Codable {
    let education: String?
    let preferredDomains: [String]?
    let preferredContract: String?
    let preferredLocation: String?
}

struct UpdateUserPreferencesRequest: Codable {
    let education: String?
    let preferredDomains: [String]?
    let preferredContract: String?
    let preferredLocation: String?
}

struct UserPreferencesResponse: Codable {
    let userPreferences: UserPreferences
}
