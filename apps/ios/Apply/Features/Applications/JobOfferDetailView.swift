//
//  JobOfferDetailView.swift
//  Apply
//

import SwiftUI

struct JobOfferDetailView: View {
    let jobOffer: JobOffer
    let companyName: String?

    @Environment(\.dismiss) private var dismiss
    @State private var showSafari = false

    init(jobOffer: JobOffer, companyName: String? = nil) {
        self.jobOffer = jobOffer
        self.companyName = companyName
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Section
                headerSection

                // Quick Info Pills
                quickInfoSection
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                // Key Info Cards
                if hasKeyInfo {
                    keyInfoSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                }

                // Description Section
                if let description = jobOffer.description, !description.isEmpty {
                    descriptionSection(description)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                }

                // Skills Section
                if let skills = jobOffer.requiredSkills, !skills.isEmpty {
                    skillsSection(skills)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                }

                // Actions Section
                actionsSection
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showSafari = true }) {
                    Image(systemName: "safari")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showSafari) {
            if let url = URL(string: jobOffer.sourceUrl) {
                SafariView(url: url)
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Match Score Badge
            if let matchScore = jobOffer.matchScore {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                        Text("\(Int(matchScore))% match")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(matchScoreColor(matchScore))
                    .cornerRadius(20)

                    Spacer()
                }
            }

            // Company Name
            if let company = companyName {
                Text(company)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }

            // Job Title
            Text(jobOffer.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            // Category
            if let category = jobOffer.category {
                Text(category)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(Color(.systemBackground))
    }

    // MARK: - Has Key Info
    private var hasKeyInfo: Bool {
        jobOffer.salaryMin != nil ||
        jobOffer.remotePolicy != nil ||
        jobOffer.duration != nil ||
        jobOffer.startDate != nil ||
        jobOffer.experienceYears != nil ||
        jobOffer.educationLevel != nil
    }

    // MARK: - Key Info Section
    private var keyInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Informations clés", icon: "info.circle")

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                // Salary
                if let salary = jobOffer.formattedSalary {
                    KeyInfoCard(
                        icon: "eurosign.circle.fill",
                        title: "Salaire",
                        value: salary,
                        color: .green
                    )
                }

                // Remote Policy
                if let remote = jobOffer.remotePolicy {
                    KeyInfoCard(
                        icon: remotePolicyIcon(remote),
                        title: "Télétravail",
                        value: remote.displayName,
                        color: remotePolicyColor(remote)
                    )
                }

                // Duration
                if let duration = jobOffer.duration {
                    KeyInfoCard(
                        icon: "clock.fill",
                        title: "Durée",
                        value: duration,
                        color: .orange
                    )
                }

                // Start Date
                if let startDate = jobOffer.startDate {
                    KeyInfoCard(
                        icon: "calendar.badge.clock",
                        title: "Début",
                        value: formatStartDate(startDate),
                        color: .blue
                    )
                }

                // Experience
                if let years = jobOffer.experienceYears {
                    KeyInfoCard(
                        icon: "briefcase.fill",
                        title: "Expérience",
                        value: years == 0 ? "Débutant" : "\(years)+ ans",
                        color: .purple
                    )
                }

                // Education
                if let education = jobOffer.educationLevel {
                    KeyInfoCard(
                        icon: "graduationcap.fill",
                        title: "Formation",
                        value: education,
                        color: .indigo
                    )
                }
            }
        }
    }

    // MARK: - Quick Info Section
    private var quickInfoSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Contract Type
                if let contractType = jobOffer.contractType {
                    InfoPill(
                        icon: "doc.text",
                        text: contractType.displayName,
                        color: contractTypeColor(contractType)
                    )
                }

                // Location
                if let location = jobOffer.location {
                    InfoPill(
                        icon: "location",
                        text: location,
                        color: .blue
                    )
                }

                // Posted Date
                if let createdAt = jobOffer.createdAt {
                    InfoPill(
                        icon: "calendar",
                        text: formatDate(createdAt),
                        color: .gray
                    )
                }
            }
        }
    }

    // MARK: - Description Section
    private func descriptionSection(_ description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Description", icon: "text.alignleft")

            Text(description)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color(.systemBackground))
                .cornerRadius(12)
        }
    }

    // MARK: - Skills Section
    private func skillsSection(_ skills: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Compétences requises", icon: "checkmark.seal")

            FlowLayout(spacing: 8) {
                ForEach(skills, id: \.self) { skill in
                    SkillTag(skill: skill)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }

    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                // TODO : Create a letter of motivation
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Créer une lettre de motivation")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(12)
            }
            Button(action: {
                // TODO : DONT WANT TO APPLY
            }) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                    Text("Ne pas postuler")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red)
                .cornerRadius(12)
            }
        }
    }

    // MARK: - Helper Functions
    private func matchScoreColor(_ score: Double) -> Color {
        if score >= 80 {
            return .green
        } else if score >= 60 {
            return .orange
        } else {
            return .blue
        }
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

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private func formatStartDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }

    private func remotePolicyIcon(_ policy: RemotePolicy) -> String {
        switch policy {
        case .none: return "building.2.fill"
        case .partial: return "house.and.flag.fill"
        case .full: return "house.fill"
        }
    }

    private func remotePolicyColor(_ policy: RemotePolicy) -> Color {
        switch policy {
        case .none: return .gray
        case .partial: return .teal
        case .full: return .green
        }
    }
}
