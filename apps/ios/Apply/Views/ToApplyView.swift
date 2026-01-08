//
//  ToApplyView.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI

struct ToApplyView: View {
    @EnvironmentObject var opportunitiesVM: OpportunitiesViewModel
    @State private var showingAddOpportunity = false

    var body: some View {
        NavigationStack {
            Group {
                if opportunitiesVM.isLoading {
                    ProgressView()
                } else if opportunitiesVM.validatedOpportunities.isEmpty {
                    ContentUnavailableView(
                        "Aucune opportunité",
                        systemImage: "tray",
                        description: Text("Ajoutez des opportunités à postuler")
                    )
                } else {
                    List {
                        ForEach(opportunitiesVM.validatedOpportunities) { opportunity in
                            NavigationLink(destination: OpportunityDetailView(opportunity: opportunity)) {
                                OpportunityRowView(opportunity: opportunity)
                            }
                        }
                        .onDelete(perform: deleteOpportunities)
                    }
                }
            }
            .navigationTitle("À postuler")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddOpportunity = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddOpportunity) {
                AddOpportunityView()
                    .environmentObject(opportunitiesVM)
            }
            .task {
                await opportunitiesVM.fetchValidatedOpportunities()
            }
            .refreshable {
                await opportunitiesVM.fetchValidatedOpportunities()
            }
        }
    }

    private func deleteOpportunities(at offsets: IndexSet) {
        for index in offsets {
            let opportunity = opportunitiesVM.validatedOpportunities[index]
            Task {
                await opportunitiesVM.deleteOpportunity(opportunity)
            }
        }
    }
}

// Simple row view for list
struct OpportunityRowView: View {
    let opportunity: Opportunity

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(opportunity.role)
                .font(.headline)
            Text(opportunity.company)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let location = opportunity.location {
                Text(location)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
