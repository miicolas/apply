//
//  ProfileView.swift
//  Apply
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    @State private var education = ""
    @State private var selectedContract: ContractType?
    @State private var selectedLocation: LocationType?

    @State private var showingAddSkillModal = false
    @State private var selectedSkill: Skill?

    @State private var showingAddExperienceModal = false
    @State private var selectedExperience: Experience?

    @State private var showError = false

    var body: some View {
        NavigationStack {
            Form {
                if viewModel.isLoading && viewModel.preferences == nil {
                    Section {
                        ProgressView("Chargement du profil...")
                    }
                } else {
                    preferencesSection
                    skillsSection
                    experiencesSection
                }
            }
            .navigationTitle("Profil")
            .task {
                await viewModel.loadProfile()
                loadPreferencesData()
            }
            .refreshable {
                await viewModel.loadProfile()
                loadPreferencesData()
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .onChange(of: viewModel.errorMessage) { _, newValue in
                showError = newValue != nil
            }
            .sheet(isPresented: $showingAddSkillModal) {
                AddSkillView(viewModel: viewModel)
            }
            .sheet(item: $selectedSkill) { skill in
                EditSkillView(viewModel: viewModel, skill: skill)
            }
            .sheet(isPresented: $showingAddExperienceModal) {
                AddExperienceView(viewModel: viewModel)
            }
            .sheet(item: $selectedExperience) { experience in
                EditExperienceView(viewModel: viewModel, experience: experience)
            }
        }
    }

    // MARK: - Preferences Section

    private var preferencesSection: some View {
        Section("Informations générales") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Formation")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextEditor(text: $education)
                    .frame(minHeight: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            }

            Picker("Type de contrat", selection: $selectedContract) {
                Text("Non spécifié").tag(nil as ContractType?)
                ForEach(ContractType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type as ContractType?)
                }
            }

            Picker("Localisation", selection: $selectedLocation) {
                Text("Non spécifié").tag(nil as LocationType?)
                ForEach(LocationType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type as LocationType?)
                }
            }

            Button("Sauvegarder les modifications") {
                Task {
                    await viewModel.updatePreferences(
                        education: education,
                        contract: selectedContract?.rawValue,
                        location: selectedLocation?.rawValue
                    )
                }
            }
            .disabled(viewModel.isLoading)
        }
    }

    // MARK: - Skills Section

    private var skillsSection: some View {
        Section {
            if viewModel.skills.isEmpty {
                Text("Aucune compétence ajoutée")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                ForEach(viewModel.skills) { skill in
                    Button {
                        selectedSkill = skill
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(skill.name)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                if let level = skill.level,
                                   let skillLevel = SkillLevel(rawValue: level) {
                                    Text(skillLevel.displayName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let skill = viewModel.skills[index]
                        Task {
                            await viewModel.deleteSkill(id: skill.id)
                        }
                    }
                }
            }

            Button {
                showingAddSkillModal = true
            } label: {
                Label("Ajouter une compétence", systemImage: "plus.circle.fill")
            }
        } header: {
            Text("Compétences")
        }
    }

    // MARK: - Experiences Section

    private var experiencesSection: some View {
        Section {
            if viewModel.experiences.isEmpty {
                Text("Aucune expérience ajoutée")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                ForEach(viewModel.experiences) { experience in
                    Button {
                        selectedExperience = experience
                    } label: {
                        HStack {
                            ExperienceRowView(experience: experience)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let experience = viewModel.experiences[index]
                        Task {
                            await viewModel.deleteExperience(id: experience.id)
                        }
                    }
                }
            }

            Button {
                showingAddExperienceModal = true
            } label: {
                Label("Ajouter une expérience", systemImage: "plus.circle.fill")
            }
        } header: {
            Text("Expériences professionnelles")
        }
    }

    // MARK: - Helpers

    private func loadPreferencesData() {
        if let preferences = viewModel.preferences {
            education = preferences.education ?? ""
            selectedContract = preferences.preferredContract.flatMap { ContractType(rawValue: $0) }
            selectedLocation = preferences.preferredLocation.flatMap { LocationType(rawValue: $0) }
        }
    }
}
