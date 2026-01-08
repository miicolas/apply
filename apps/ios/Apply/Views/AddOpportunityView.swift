import SwiftUI

struct AddOpportunityView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var opportunitiesVM: OpportunitiesViewModel

    @State private var company = ""
    @State private var role = ""
    @State private var url = ""
    @State private var source = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Entreprise")) {
                    TextField("Nom de la société", text: $company)
                }

                Section(header: Text("Rôle")) {
                    TextField("Titre du poste", text: $role)
                }

                Section(header: Text("Lien vers l'offre")) {
                    TextField("URL", text: $url)
                        .autocapitalization(.none)
                }

                Section(header: Text("Source")) {
                    TextField("LinkedIn, site web, etc.", text: $source)
                }

                Section(header: Text("Localisation")) {
                    TextField("Paris, Remote, etc.", text: $location)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }

                Section {
                    Button(action: addOpportunity) {
                        if isSubmitting {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Label("Ajouter une candidature", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(company.isEmpty || role.isEmpty || isSubmitting)
                }
            }
            .navigationTitle("Nouvelle opportunité")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func addOpportunity() {
        isSubmitting = true

        Task {
            let success = await opportunitiesVM.createOpportunity(
                company: company,
                role: role,
                location: location,
                url: url,
                source: source,
                notes: notes
            )

            isSubmitting = false

            if success {
                dismiss()
            } else {
                errorMessage = opportunitiesVM.error ?? "Une erreur est survenue"
                showError = true
            }
        }
    }
}
