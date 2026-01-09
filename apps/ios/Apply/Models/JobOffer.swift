//
//  JobOffer.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct JobOffer: Identifiable, Codable, Hashable {
    let id: String
    let sourceUrl: String
    let title: String
    let companyId: String
    let category: String?
    let description: String?
    let requiredSkills: [String]?
    let isPublic: Bool
    let isActive: Bool
    let createdByUserId: String
    let publicAt: Date?
    let createdAt: Date?
    let updatedAt: Date?
    
    // Computed property for match score (calculated client-side)
    var matchScore: Double? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case sourceUrl = "source_url"
        case title
        case companyId = "company_id"
        case category
        case description
        case requiredSkills = "required_skills"
        case isPublic = "is_public"
        case isActive = "is_active"
        case createdByUserId = "created_by_user_id"
        case publicAt = "public_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case matchScore
    }
}
