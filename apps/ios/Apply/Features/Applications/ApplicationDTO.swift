//
//  ApplicationDTO.swift
//  Apply
//

import Foundation

// Request/Response types
struct CreateApplicationRequest: Codable {
    let jobOfferId: String
    let status: ApplicationStatus?
    let coverLetter: String?
    let emailContent: String?
}

struct UpdateApplicationRequest: Codable {
    let status: ApplicationStatus?
    let coverLetter: String?
    let emailContent: String?
    let appliedAt: Date?
    let nextFollowUpAt: Date?
}

struct ApplicationResponse: Codable {
    let application: Application
}

struct ApplicationsResponse: Codable {
    let applications: [Application]
}
