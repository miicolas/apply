//
//  Experience.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct Experience: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let title: String
    let company: String?
    let description: String?
    let startDate: Date?
    let endDate: Date?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case company
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
