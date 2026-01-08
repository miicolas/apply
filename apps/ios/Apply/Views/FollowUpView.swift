//
//  FollowUpView.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI

struct FollowUpView: View {
    @EnvironmentObject var opportunitiesVM: OpportunitiesViewModel
    @State private var showAddOpportunityView = false
    @State private var showSignOutConfirmation = false

    private let authService = AuthService.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    if opportunitiesVM.appliedOpportunities.isEmpty {
                        ContentUnavailableView(
                            "Aucune opportunité",
                            systemImage: "tray",
                            description: Text("Ajoutez des opportunités à postuler")
                        )
                    } else {
                        List {
                            ForEach(opportunitiesVM.appliedOpportunities) { opportunity in
                                NavigationLink(value: opportunity) {
                                    OpportunityRowView(opportunity: opportunity)
                                }
                            }
                        }
                        .navigationDestination(for: Opportunity.self) { opportunity in
                            OpportunityDetailView(opportunity: opportunity, onApplied: nil)
                                .environmentObject(opportunitiesVM)
                        }
                    }

                    Spacer()

                    Button(action: { showAddOpportunityView = true }) {
                        Label("Ajouter une candidature", systemImage: "plus")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                    Button(role: .destructive) {
                        showSignOutConfirmation = true
                    } label: {
                        Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 16)
                }
                
            }
            .sheet(isPresented: $showAddOpportunityView) {
                AddOpportunityView()
            }
            .confirmationDialog(
                "Voulez-vous vous déconnecter ?",
                isPresented: $showSignOutConfirmation,
                titleVisibility: .visible
            ) {
                Button("Se déconnecter", role: .destructive) {
                    Task {
                        await authService.signOut()
                    }
                }
                Button("Annuler", role: .cancel) {}
            }
            .navigationTitle("Suivi")
            .task {
                await opportunitiesVM.fetchAppliedOpportunities()
            }
            .refreshable {
                await opportunitiesVM.fetchAppliedOpportunities()
            }
        }
    }
}

