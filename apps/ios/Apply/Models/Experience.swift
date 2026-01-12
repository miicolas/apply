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
    let startDate: String?
    let endDate: String?
    let createdAt: Date?
    let updatedAt: Date?

    // Helper to get startDate as Date
    var startDateAsDate: Date? {
        guard let startDate = startDate else { return nil }
        return Self.dateFormatter.date(from: startDate)
    }

    // Helper to get endDate as Date
    var endDateAsDate: Date? {
        guard let endDate = endDate else { return nil }
        return Self.dateFormatter.date(from: endDate)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
