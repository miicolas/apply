//
//  FollowUpView.swift
//  Apply
//

import SwiftUI

struct FollowUpView: View {
    // TODO: Replace with ApplicationViewModel when created
    @State private var applications: [Application] = []
    @State private var isLoading = false
    @State private var error: String?

    private let authService = AuthService.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    if applications.isEmpty {
                        ContentUnavailableView(
                            "Aucune candidature",
                            systemImage: "tray",
                            description: Text("Vos candidatures en cours apparaîtront ici")
                        )
                    } else {
                        List {
                            ForEach(applications) { application in
                                NavigationLink(value: application) {
                                    ApplicationRowView(application: application)
                                }
                            }
                        }
                        .navigationDestination(for: Application.self) { application in
                            // TODO: Create ApplicationDetailView
                            Text("Application Detail")
                        }
                    }

                    Spacer()

                    Button(action: {
                        // TODO: Show AddJobOfferView
                    }) {
                        Label("Ajouter une candidature", systemImage: "plus")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                    Button(role: .destructive) {
                        // TODO: Show sign out confirmation
                    } label: {
                        Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Suivi")
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
        // TODO: Implement API call to fetch applications with status != "to_apply" and != "rejected"
        applications = []
        isLoading = false
    }
}
