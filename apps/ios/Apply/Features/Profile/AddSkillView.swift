//
//  AddSkillView.swift
//  Apply
//

import SwiftUI

struct AddSkillView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel

    @State private var name = ""
    @State private var selectedLevel: SkillLevel = .intermediate

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
            .navigationTitle("Ajouter une compétence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        Task {
                            let request = CreateSkillRequest(
                                name: name,
                                level: selectedLevel.rawValue
                            )
                            await viewModel.addSkill(request)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
