//
//  ExperienceRowView.swift
//  Apply
//

import SwiftUI

struct ExperienceRowView: View {
    let experience: Experience

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(experience.title)
                .font(.headline)
                .foregroundColor(.primary)

            if let company = experience.company, !company.isEmpty {
                HStack(spacing: 4) {
                    Text(company)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if let dates = formattedDates {
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(dates)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            } else if let dates = formattedDates {
                Text(dates)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if let description = experience.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.vertical, 4)
    }

    private var formattedDates: String? {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM yyyy"
        displayFormatter.locale = Locale(identifier: "fr_FR")

        var parts: [String] = []

        if let startDate = experience.startDateAsDate {
            parts.append(displayFormatter.string(from: startDate))
        }

        if let endDate = experience.endDateAsDate {
            parts.append(displayFormatter.string(from: endDate))
        } else if experience.startDate != nil {
            parts.append("Aujourd'hui")
        }

        return parts.isEmpty ? nil : parts.joined(separator: " - ")
    }
}
