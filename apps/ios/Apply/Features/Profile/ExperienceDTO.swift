//
//  ExperienceDTO.swift
//  Apply
//

import Foundation

struct CreateExperienceRequest: Codable {
    let title: String
    let company: String?
    let description: String?
    let startDate: String?
    let endDate: String?
}

struct UpdateExperienceRequest: Codable {
    let title: String
    let company: String?
    let description: String?
    let startDate: String?
    let endDate: String?
}
