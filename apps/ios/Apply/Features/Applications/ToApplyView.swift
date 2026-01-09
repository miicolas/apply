//
//  ToApplyView.swift
//  Apply
//

import SwiftUI

struct ToApplyView: View {
    // TODO: Replace with ApplicationViewModel when created
    @State private var applications: [Application] = []
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if applications.isEmpty {
                    ContentUnavailableView(
                        "Aucune candidature",
                        systemImage: "tray",
                        description: Text("Ajoutez des offres à postuler")
                    )
                } else {
                    List {
                        ForEach(applications) { application in
                            NavigationLink(value: application) {
                                ApplicationRowView(application: application)
                            }
                        }
                        .onDelete(perform: deleteApplications)
                    }
                    .navigationDestination(for: Application.self) { application in
                        // TODO: Create ApplicationDetailView
                        Text("Application Detail")
                    }
                }
            }
            .navigationTitle("À postuler")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Show AddJobOfferView
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await fetchApplications()
            }
            .refreshable {
                await fetchApplications()
            }
        }
    }

    private func fetchApplications() async {
        isLoading = true
        error = nil
        // TODO: Implement API call to fetch applications with status "to_apply"
        applications = []
        isLoading = false
    }

    private func deleteApplications(at offsets: IndexSet) {
        for index in offsets {
            let application = applications[index]
            Task {
                // TODO: Delete application via API
            }
        }
    }
}

struct ApplicationRowView: View {
    let application: Application

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Job Title") // TODO: Load from jobOffer
                .font(.headline)
            Text("Company Name") // TODO: Load from jobOffer.companyId
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
