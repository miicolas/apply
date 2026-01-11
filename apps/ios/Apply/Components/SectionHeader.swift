//
//  SectionHeader.swift
//  Apply
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.blue)
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    SectionHeader(title: "Informations", icon: "info.circle")
}
