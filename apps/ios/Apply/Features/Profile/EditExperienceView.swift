//
//  EditExperienceView.swift
//  Apply
//

import SwiftUI

struct EditExperienceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    let experience: Experience

    @State private var title: String
    @State private var company: String
    @State private var description: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var isCurrentPosition: Bool
    @State private var hasStartDate: Bool
    @State private var hasEndDate: Bool

    init(viewModel: ProfileViewModel, experience: Experience) {
        self.viewModel = viewModel
        self.experience = experience

        _title = State(initialValue: experience.title)
        _company = State(initialValue: experience.company ?? "")
        _description = State(initialValue: experience.description ?? "")
        _startDate = State(initialValue: experience.startDateAsDate ?? Date())
        _endDate = State(initialValue: experience.endDateAsDate ?? Date())
        _hasStartDate = State(initialValue: experience.startDate != nil)
        _hasEndDate = State(initialValue: experience.endDate != nil)
        _isCurrentPosition = State(initialValue: experience.endDate == nil && experience.startDate != nil)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Informations principales") {
                    TextField("Titre du poste", text: $title)

                    TextField("Entreprise (optionnel)", text: $company)
                }

                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }

                Section("Dates") {
                    Toggle("Date de début", isOn: $hasStartDate)

                    if hasStartDate {
                        DatePicker("Date de début", selection: $startDate, displayedComponents: .date)
                    }

                    if !isCurrentPosition {
                        Toggle("Date de fin", isOn: $hasEndDate)

                        if hasEndDate {
                            DatePicker("Date de fin", selection: $endDate, displayedComponents: .date)
                        }
                    }

                    Toggle("Poste actuel", isOn: $isCurrentPosition)
                        .onChange(of: isCurrentPosition) { _, newValue in
                            if newValue {
                                hasEndDate = false
                            }
                        }
                }
            }
            .navigationTitle("Modifier l'expérience")
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
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"

                            let request = UpdateExperienceRequest(
                                title: title,
                                company: company.isEmpty ? nil : company,
                                description: description.isEmpty ? nil : description,
                                startDate: hasStartDate ? dateFormatter.string(from: startDate) : nil,
                                endDate: hasEndDate ? dateFormatter.string(from: endDate) : nil
                            )
                            await viewModel.updateExperience(id: experience.id, request)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
