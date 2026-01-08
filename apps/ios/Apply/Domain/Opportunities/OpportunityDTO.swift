//
//  OpportunityDTO.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

// Request/Response types
struct CreateOpportunityRequest: Codable {
    let company: String
    let role: String
    let location: String?
    let priority: Priority
    let status: OpportunityStatus
    let url: String?
    let source: String?
    let notes: String?
}

struct UpdateStatusRequest: Codable {
    let status: OpportunityStatus
}

struct OpportunityResponse: Codable {
    let opportunity: Opportunity
}

struct OpportunitiesResponse: Codable {
    let opportunities: [Opportunity]
}

// Error response model
struct ErrorResponse: Codable {
    let error: String
}
