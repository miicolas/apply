//
//  JobOffer.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

enum ContractType: String, Codable, CaseIterable {
    case cdi
    case cdd
    case alternance
    case stage
    case freelance
    case interim

    var displayName: String {
        switch self {
        case .cdi: return "CDI"
        case .cdd: return "CDD"
        case .alternance: return "Alternance"
        case .stage: return "Stage"
        case .freelance: return "Freelance"
        case .interim: return "Intérim"
        }
    }
}

enum RemotePolicy: String, Codable {
    case none
    case partial
    case full

    var displayName: String {
        switch self {
        case .none: return "Sur site"
        case .partial: return "Hybride"
        case .full: return "Full remote"
        }
    }
}

struct JobOffer: Identifiable, Codable, Hashable {
    let id: String
    let sourceUrl: String
    let title: String
    let companyId: String
    let category: String?
    let description: String?
    let requiredSkills: [String]?
    let contractType: ContractType?
    let location: String?
    let salaryMin: Int?
    let salaryMax: Int?
    let duration: String?
    let remotePolicy: RemotePolicy?
    let startDate: Date?
    let experienceYears: Int?
    let educationLevel: String?
    let isPublic: Bool
    let isActive: Bool
    let createdByUserId: String
    let publicAt: Date?
    let createdAt: Date?
    let updatedAt: Date?

    // Computed property for match score (calculated client-side, not from API)
    var matchScore: Double? = nil

    // Formatted salary display
    var formattedSalary: String? {
        guard let min = salaryMin else { return nil }
        if let max = salaryMax, max != min {
            return "\(formatCurrency(min)) - \(formatCurrency(max)) €/mois"
        }
        return "\(formatCurrency(min)) €/mois"
    }

    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
