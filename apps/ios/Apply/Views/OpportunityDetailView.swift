import SwiftUI

struct OpportunityDetailView: View {
    let opportunity: Opportunity
    @Environment(\.openURL) private var openURL

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
                // plus tard : marquer comme postulé
            } label: {
                Label("Marquer comme postulé", systemImage: "paperplane")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding()
    }
}
