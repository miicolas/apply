//
//  AddExperienceView.swift
//  Apply
//

import SwiftUI

struct AddExperienceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel

    @State private var title = ""
    @State private var company = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isCurrentPosition = false
    @State private var hasStartDate = false
    @State private var hasEndDate = false

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
            .navigationTitle("Ajouter une expérience")
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
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"

                            let request = CreateExperienceRequest(
                                title: title,
                                company: company.isEmpty ? nil : company,
                                description: description.isEmpty ? nil : description,
                                startDate: hasStartDate ? dateFormatter.string(from: startDate) : nil,
                                endDate: hasEndDate ? dateFormatter.string(from: endDate) : nil
                            )
                            await viewModel.addExperience(request)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
