//
//  Application.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

enum ApplicationStatus: String, Codable {
    case toApply = "to_apply"
    case applied = "applied"
    case followUp = "follow_up"
    case interview = "interview"
    case offer = "offer"
    case rejected = "rejected"
}

struct Application: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let jobOfferId: String
    var status: ApplicationStatus
    let coverLetter: String?
    let emailContent: String?
    let appliedAt: Date?
    let nextFollowUpAt: Date?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case jobOfferId = "job_offer_id"
        case status
        case coverLetter = "cover_letter"
        case emailContent = "email_content"
        case appliedAt = "applied_at"
        case nextFollowUpAt = "next_follow_up_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
