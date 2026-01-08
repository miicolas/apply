import SwiftUI

struct OpportunityDetailView: View {
    let opportunity: Opportunity
    var onApplied: (() -> Void)?
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var opportunitiesVM: OpportunitiesViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text(opportunity.company)
                .font(.largeTitle.bold())

            Text(opportunity.role)
                .font(.title3)
                .foregroundStyle(.secondary)

            Divider()

            if let location = opportunity.location {
                HStack {
                    Image(systemName: "location.fill")
                    Text(location)
                }
            }

            Divider()

            if let urlString = opportunity.url, let url = URL(string: urlString) {
                Button {
                    openURL(url)
                } label: {
                    Label("Voir l'offre", systemImage: "link")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            Button {
                markAsApplied()
            } label: {
                Label("Marquer comme postulé", systemImage: "paperplane")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding()
    }

    private func markAsApplied() {
        Task { @MainActor in
            await opportunitiesVM.applyOpportunity(opportunity)
            onApplied?()
            dismiss()
        }
    }
}
