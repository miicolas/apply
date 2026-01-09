//
//  Skill.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct Skill: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let name: String
    let level: String?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case level
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum SkillLevel: String, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
}
