//
//  ToApplyView.swift
//  Apply
//

import SwiftUI

struct ToApplyView: View {
    @State private var jobOffers: [JobOffer] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isPresentingAddJobOfferView = false

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if jobOffers.isEmpty {
                    ContentUnavailableView(
                        "Aucune offre",
                        systemImage: "tray",
                        description: Text("Ajoutez des offres d'emploi")
                    )
                } else {
                    List {
                        ForEach(jobOffers) { jobOffer in
                            NavigationLink(value: jobOffer) {
                                JobOfferRowView(jobOffer: jobOffer)
                            }
                        }
                        .onDelete(perform: deleteJobOffers)
                    }
                    .navigationDestination(for: JobOffer.self) { jobOffer in
                        JobOfferDetailView(jobOffer: jobOffer)
                    }
                }
            }
            .navigationTitle("Mes offres")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingAddJobOfferView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await fetchJobOffers()
            }
            .refreshable {
                await fetchJobOffers()
            }
            .sheet(isPresented: $isPresentingAddJobOfferView) {
                AddJobOfferView()
            }
        }
    }

    @MainActor
    private func fetchJobOffers() async {
        errorMessage = nil
        do {
            jobOffers = try await getAllJobOffers()
            print("Fetched \(jobOffers.count) job offers")
        } catch {
            print("Error fetching job offers: \(error)")
            errorMessage = error.localizedDescription
        }
    }

    private func deleteJobOffers(at offsets: IndexSet) {
        for index in offsets {
            let jobOffer = jobOffers[index]
            Task {
                // TODO: Delete job offer via API
            }
        }
    }
}

struct JobOfferRowView: View {
    let jobOffer: JobOffer

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(jobOffer.title)
                .font(.headline)

            HStack(spacing: 8) {
                if let contractType = jobOffer.contractType {
                    Text(contractType.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(contractTypeColor(contractType).opacity(0.15))
                        .foregroundColor(contractTypeColor(contractType))
                        .cornerRadius(6)
                }

                if let location = jobOffer.location {
                    Label(location, systemImage: "location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if let skills = jobOffer.requiredSkills, !skills.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(skills.prefix(5), id: \.self) { skill in
                            Text(skill)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func contractTypeColor(_ type: ContractType) -> Color {
        switch type {
        case .cdi: return .green
        case .cdd: return .orange
        case .alternance: return .blue
        case .stage: return .purple
        case .freelance: return .pink
        case .interim: return .yellow
        }
    }
}
