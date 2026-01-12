//
//  EditSkillView.swift
//  Apply
//

import SwiftUI

struct EditSkillView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    let skill: Skill

    @State private var name: String
    @State private var selectedLevel: SkillLevel

    init(viewModel: ProfileViewModel, skill: Skill) {
        self.viewModel = viewModel
        self.skill = skill
        _name = State(initialValue: skill.name)
        _selectedLevel = State(initialValue: SkillLevel(rawValue: skill.level ?? "intermediate") ?? .intermediate)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Compétence") {
                    TextField("Ex: Swift, React, Python...", text: $name)
                        .autocorrectionDisabled()
                }

                Section("Niveau") {
                    Picker("Niveau", selection: $selectedLevel) {
                        ForEach(SkillLevel.allCases, id: \.self) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Modifier la compétence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Sauvegarder") {
                        Task {
                            let request = UpdateSkillRequest(
                                name: name,
                                level: selectedLevel.rawValue
                            )
                            await viewModel.updateSkill(id: skill.id, request)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
