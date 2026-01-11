import SwiftUI

struct AddJobOfferView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var analysisService = JobAnalysisService()

    @State private var url: String = ""
    @State private var showError = false
    @State private var errorMessage: String? = nil

    var onJobCreated: ((String) -> Void)?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if analysisService.status == .idle {
                    urlInputView
                } else {
                    analysisProgressView
                }
            }
            .navigationTitle("Ajouter une offre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        analysisService.cancel()
                        dismiss()
                    }
                }

                if analysisService.status == .idle {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Analyser") {
                            startAnalysis()
                        }
                        .disabled(url.isEmpty || !isValidURL(url))
                        .fontWeight(.semibold)
                    }
                }
            }
            .onChange(of: analysisService.status) { _, newStatus in
                handleStatusChange(newStatus)
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK") {
                    showError = false
                    errorMessage = nil
                    analysisService.reset()
                }
            } message: {
                Text(errorMessage ?? analysisService.error ?? "Une erreur est survenue")
            }
        }
    }

    private var urlInputView: some View {
        Form {
            Section {
                TextField("https://www.linkedin.com/jobs/...", text: $url)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.go)
                    .onSubmit {
                        if isValidURL(url) {
                            startAnalysis()
                        }
                    }
            } header: {
                Text("URL de l'offre")
            } footer: {
                Text("Collez l'URL de l'offre d'emploi (LinkedIn, Welcome to the Jungle, Indeed, etc.)")
            }

            Section {
                VStack(alignment: .leading, spacing: 12) {
                    featureRow(icon: "sparkles", text: "Extraction automatique des informations")
                    featureRow(icon: "building.2", text: "Detection de l'entreprise")
                    featureRow(icon: "list.bullet", text: "Identification des competences requises")
                    featureRow(icon: "tag", text: "Categorisation intelligente")
                }
                .padding(.vertical, 8)
            } header: {
                Text("Notre IA va analyser")
            }
        }
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Analysis Progress View

    private var analysisProgressView: some View {
        VStack(spacing: 32) {
            Spacer()

            // Progress circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: analysisService.progress / 100)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: analysisService.progress)

                VStack(spacing: 4) {
                    Text("\(Int(analysisService.progress))%")
                        .font(.system(size: 36, weight: .bold, design: .rounded))

                    Text(statusEmoji)
                        .font(.title2)
                }
            }

            // Current step
            VStack(spacing: 8) {
                Text(analysisService.currentStep)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(statusDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 32)

            Spacer()

            // Cancel button
            if analysisService.status == .running || analysisService.status == .pending {
                Button(role: .cancel) {
                    analysisService.cancel()
                } label: {
                    Text("Annuler l'analyse")
                        .foregroundColor(.red)
                }
                .padding(.bottom, 32)
            }
        }
    }

    private var statusEmoji: String {
        switch analysisService.status {
        case .idle: return ""
        case .pending: return "..."
        case .running: return ""
        case .completed: return ""
        case .failed: return ""
        }
    }

    private var statusDescription: String {
        switch analysisService.status {
        case .idle: return ""
        case .pending: return "En attente de traitement..."
        case .running: return "Analyse en cours..."
        case .completed: return "Analyse terminee!"
        case .failed: return "L'analyse a echoue"
        }
    }

    // MARK: - Actions

    private func startAnalysis() {
        Task {
            do {
                try await analysisService.analyzeJobOffer(url: url)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    private func handleStatusChange(_ status: JobAnalysisService.JobAnalysisStatus) {
        switch status {
        case .completed:
            if let result = analysisService.result {
                onJobCreated?(result.jobOfferId)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    dismiss()
                }
            }
        case .failed:
            showError = true
        default:
            break
        }
    }

    private func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}

#Preview {
    AddJobOfferView()
}
