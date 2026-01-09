//
//  JobOfferDTO.swift
//  Apply
//

import Foundation

// Request/Response types
struct CreateJobOfferRequest: Codable {
    let sourceUrl: String
    let title: String
    let companyId: String
    let category: String?
    let description: String?
    let requiredSkills: [String]?
}

struct UpdateJobOfferRequest: Codable {
    let title: String?
    let category: String?
    let description: String?
    let requiredSkills: [String]?
    let isPublic: Bool?
    let isActive: Bool?
}

struct JobOfferResponse: Codable {
    let jobOffer: JobOffer
}

struct JobOffersResponse: Codable {
    let jobOffers: [JobOffer]
}
