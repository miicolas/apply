import SwiftUI

struct DiscoveryView: View {
    @EnvironmentObject var opportunitiesVM: OpportunitiesViewModel

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                    if opportunitiesVM.newOpportunities.isEmpty {
                        VStack(spacing: 24) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            Text("Plus d'opportunités")
                                .font(.title2)
                                .foregroundColor(.secondary)

                            Button(action: {
                                Task {
                                    await opportunitiesVM.fetchNewOpportunities()
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
                        ForEach(Array(opportunitiesVM.newOpportunities.reversed().enumerated()), id: \.element.id) { index, opp in
                            OpportunityCard(
                                opportunity: opp,
                                onSwipeRight: {
                                    validate(opp)
                                },
                                onSwipeLeft: {
                                    ignore(opp)
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
                            .zIndex(Double(opportunitiesVM.newOpportunities.count - index))
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
                            await opportunitiesVM.fetchNewOpportunities()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task {
                await opportunitiesVM.fetchNewOpportunities()
            }
        }
    }

    private func validate(_ opportunity: Opportunity) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            Task {
                await opportunitiesVM.validateOpportunity(opportunity)
            }
        }
    }

    private func ignore(_ opportunity: Opportunity) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            Task {
                await opportunitiesVM.ignoreOpportunity(opportunity)
            }
        }
    }
}
