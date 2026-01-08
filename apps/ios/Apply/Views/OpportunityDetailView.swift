import SwiftUI

struct OpportunityDetailView: View {
    let opportunity: Opportunity

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text(opportunity.company)
                .font(.largeTitle.bold())

            Text(opportunity.role)
                .font(.title3)
                .foregroundStyle(.secondary)

            Divider()

            HStack {
                Image(systemName: "location.fill")
                Text(opportunity.location)
            }

            Divider()

            Button {
                if let url = URL(string: opportunity.url) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label("Voir l’offre", systemImage: "link")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

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
