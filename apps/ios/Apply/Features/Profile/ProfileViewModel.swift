//
//  ProfileViewModel.swift
//  Apply
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var preferences: UserPreferences?
    @Published var skills: [Skill] = []
    @Published var experiences: [Experience] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Load Profile

    func loadProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            async let preferencesTask = getUserPreferences()
            async let skillsTask = getAllSkills()
            async let experiencesTask = getAllExperiences()

            let (loadedPreferences, loadedSkills, loadedExperiences) = try await (preferencesTask, skillsTask, experiencesTask)

            preferences = loadedPreferences
            skills = loadedSkills
            experiences = loadedExperiences
        } catch {
            errorMessage = "Erreur lors du chargement du profil: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - User Preferences

    func updatePreferences(education: String?, contract: String?, location: String?) async {
        isLoading = true
        errorMessage = nil

        let request = UpdateUserPreferencesRequest(
            education: education?.isEmpty == true ? nil : education,
            preferredContract: contract,
            preferredLocation: location
        )

        do {
            preferences = try await updateUserPreferences(request)
        } catch {
            errorMessage = "Erreur lors de la mise à jour des préférences: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Skills

    func addSkill(_ request: CreateSkillRequest) async {
        isLoading = true
        errorMessage = nil

        do {
            let newSkill = try await createSkill(request)
            skills.append(newSkill)
        } catch {
            errorMessage = "Erreur lors de l'ajout de la compétence: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func updateSkill(id: String, _ request: UpdateSkillRequest) async {
        isLoading = true
        errorMessage = nil

        do {
            let updatedSkill = try await Apply.updateSkill(id: id, request)
            if let index = skills.firstIndex(where: { $0.id == id }) {
                skills.remove(at: index)
                skills.insert(updatedSkill, at: index)
            }
        } catch {
            errorMessage = "Erreur lors de la mise à jour de la compétence: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func deleteSkill(id: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await Apply.deleteSkill(id: id)
            skills.removeAll { $0.id == id }
        } catch {
            errorMessage = "Erreur lors de la suppression de la compétence: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Experiences

    func addExperience(_ request: CreateExperienceRequest) async {
        isLoading = true
        errorMessage = nil

        do {
            let newExperience = try await createExperience(request)
            experiences.append(newExperience)
        } catch {
            errorMessage = "Erreur lors de l'ajout de l'expérience: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func updateExperience(id: String, _ request: UpdateExperienceRequest) async {
        isLoading = true
        errorMessage = nil

        do {
            let updatedExperience = try await Apply.updateExperience(id: id, request)
            if let index = experiences.firstIndex(where: { $0.id == id }) {
                experiences.remove(at: index)
                experiences.insert(updatedExperience, at: index)
            }
        } catch {
            errorMessage = "Erreur lors de la mise à jour de l'expérience: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func deleteExperience(id: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await Apply.deleteExperience(id: id)
            experiences.removeAll { $0.id == id }
        } catch {
            errorMessage = "Erreur lors de la suppression de l'expérience: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
