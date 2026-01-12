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
    let createdAt: String?
    let updatedAt: String?
}

enum SkillLevel: String, Codable, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"

    var displayName: String {
        switch self {
        case .beginner: return "Débutant"
        case .intermediate: return "Intermédiaire"
        case .advanced: return "Avancé"
        }
    }
}
