//
//  DiscoveryView.swift
//  Apply
//

import SwiftUI

struct DiscoveryView: View {
    // TODO: Replace with JobOfferViewModel when created
    @State private var jobOffers: [JobOffer] = []
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                    if jobOffers.isEmpty {
                        VStack(spacing: 24) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            Text("Plus d'offres")
                                .font(.title2)
                                .foregroundColor(.secondary)

                            Button(action: {
                                Task {
                                    await fetchJobOffers()
                                }
                            }) {
                                Label("Actualiser", systemImage: "arrow.clockwise")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                        }
                    } else {
                        ForEach(Array(jobOffers.reversed().enumerated()), id: \.element.id) { index, jobOffer in
                            JobOfferCard(
                                jobOffer: jobOffer,
                                companyName: nil, // TODO: Load company name from companyId
                                onSwipeRight: {
                                    saveJobOffer(jobOffer)
                                },
                                onSwipeLeft: {
                                    ignoreJobOffer(jobOffer)
                                }
                            )
                            .frame(
                                width: max(0, geometry.size.width - 40),
                                height: max(0, geometry.size.height * 0.7)
                            )
                            .offset(
                                x: 0,
                                y: CGFloat(index) * 8
                            )
                            .scaleEffect(1 - CGFloat(index) * 0.05)
                            .zIndex(Double(jobOffers.count - index))
                            .opacity(index < 3 ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .navigationTitle("Découverte")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await fetchJobOffers()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task {
                await fetchJobOffers()
            }
        }
    }

    private func fetchJobOffers() async {
        isLoading = true
        error = nil
        // TODO: Implement API call to fetch public job offers
        // For now, empty array
        jobOffers = []
        isLoading = false
    }

    private func saveJobOffer(_ jobOffer: JobOffer) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            jobOffers.removeAll { $0.id == jobOffer.id }
            // TODO: Create application with status "to_apply"
        }
    }

    private func ignoreJobOffer(_ jobOffer: JobOffer) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            jobOffers.removeAll { $0.id == jobOffer.id }
            // TODO: Optionally track ignored offers
        }
    }
}
