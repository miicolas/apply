//
//  InfoPill.swift
//  Apply
//

import SwiftUI

struct InfoPill: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(.system(size: 13, weight: .medium))
        }
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.12))
        .cornerRadius(20)
    }
}

#Preview {
    HStack {
        InfoPill(icon: "location", text: "Paris", color: .blue)
        InfoPill(icon: "doc.text", text: "CDI", color: .green)
    }
}
