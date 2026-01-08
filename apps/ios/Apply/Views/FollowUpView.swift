//
//  FollowUpView.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI

struct FollowUpView: View {
    @State private var showAddOpportunityView = false
    @State private var showSignOutConfirmation = false

    private let authService = AuthService.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Button(action: { showAddOpportunityView = true }) {
                    Label("Ajouter une candidature", systemImage: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background(Color.green)
                        .cornerRadius(12)
                }

                Spacer()

                Button(role: .destructive) {
                    showSignOutConfirmation = true
                } label: {
                    Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.subheadline)
                }
                .padding(.bottom, 32)
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
        }
    }
}
