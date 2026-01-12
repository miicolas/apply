//
//  SkillDTO.swift
//  Apply
//

import Foundation

struct CreateSkillRequest: Codable {
    let name: String
    let level: String?
}

struct UpdateSkillRequest: Codable {
    let name: String
    let level: String?
}
