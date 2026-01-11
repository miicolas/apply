//
//  KeyInfoCard.swift
//  Apply
//

import SwiftUI

struct KeyInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        KeyInfoCard(icon: "eurosign.circle.fill", title: "Salaire", value: "2 800 - 3 000 €/mois", color: .green)
        KeyInfoCard(icon: "building.2.fill", title: "Télétravail", value: "Sur site", color: .gray)
        KeyInfoCard(icon: "briefcase.fill", title: "Expérience", value: "5+ ans", color: .purple)
        KeyInfoCard(icon: "graduationcap.fill", title: "Formation", value: "Bac +5", color: .indigo)
    }
    .padding()
}
