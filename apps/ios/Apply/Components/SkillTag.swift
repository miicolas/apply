//
//  SkillTag.swift
//  Apply
//

import SwiftUI

struct SkillTag: View {
    let skill: String

    var body: some View {
        Text(skill)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray5))
            .cornerRadius(8)
    }
}

#Preview {
    HStack {
        SkillTag(skill: "Swift")
        SkillTag(skill: "SwiftUI")
        SkillTag(skill: "iOS")
    }
}
