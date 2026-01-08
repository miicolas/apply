//
//  OpportunitiesViewModel.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OpportunitiesViewModel: ObservableObject {
    @Published var newOpportunities: [Opportunity] = []
    @Published var validatedOpportunities: [Opportunity] = []
    @Published var ignoredOpportunities: [Opportunity] = []
    @Published var isLoading = false
    @Published var error: String?

    private let apiService = APIService.shared
    private let authService = AuthService.shared

    private func handleAuthError(_ error: Error) {
        if case APIError.unauthorized = error {
            Task {
                await authService.signOut()
            }
        }
    }

    func clearAll() {
        newOpportunities.removeAll()
        validatedOpportunities.removeAll()
        ignoredOpportunities.removeAll()
    }

    // MARK: - Queries

    func fetchOpportunities(status: OpportunityStatus? = nil) async {
        isLoading = true
        error = nil

        do {
            let opportunities = try await apiService.getOpportunities(status: status)

            if let status = status {
                switch status {
                case .new:
                    newOpportunities = opportunities
                case .validated:
                    validatedOpportunities = opportunities
                case .ignored:
                    ignoredOpportunities = opportunities
                }
            } else {
                newOpportunities = opportunities.filter { $0.status == .new }
                validatedOpportunities = opportunities.filter { $0.status == .validated }
                ignoredOpportunities = opportunities.filter { $0.status == .ignored }
            }
        } catch {
            self.error = error.localizedDescription
            handleAuthError(error)
        }

        isLoading = false
    }

    func fetchNewOpportunities() async {
        await fetchOpportunities(status: .new)
    }

    func fetchValidatedOpportunities() async {
        await fetchOpportunities(status: .validated)
    }

    // MARK: - Mutations

    func createOpportunity(
        company: String,
        role: String,
        location: String?,
        url: String?,
        source: String?,
        notes: String?
    ) async -> Bool {
        isLoading = true
        error = nil

        let request = CreateOpportunityRequest(
            company: company,
            role: role,
            location: location?.isEmpty == false ? location : nil,
            priority: .A,
            status: .validated,
            url: url?.isEmpty == false ? url : nil,
            source: source?.isEmpty == false ? source : nil,
            notes: notes?.isEmpty == false ? notes : nil
        )

        do {
            let newOpportunity = try await apiService.createOpportunity(request)
            validatedOpportunities.insert(newOpportunity, at: 0)
            isLoading = false
            return true
        } catch {
            self.error = error.localizedDescription
            handleAuthError(error)
            isLoading = false
            return false
        }
    }

    func validateOpportunity(_ opportunity: Opportunity) async {
        do {
            let updated = try await apiService.updateOpportunityStatus(
                id: opportunity.id,
                status: .validated
            )
            newOpportunities.removeAll { $0.id == opportunity.id }
            validatedOpportunities.insert(updated, at: 0)
        } catch {
            self.error = error.localizedDescription
            handleAuthError(error)
        }
    }

    func ignoreOpportunity(_ opportunity: Opportunity) async {
        do {
            let updated = try await apiService.updateOpportunityStatus(
                id: opportunity.id,
                status: .ignored
            )
            newOpportunities.removeAll { $0.id == opportunity.id }
            ignoredOpportunities.append(updated)
        } catch {
            self.error = error.localizedDescription
            handleAuthError(error)
        }
    }

    func recoverIgnoredOpportunity(_ opportunity: Opportunity) async {
        do {
            let updated = try await apiService.updateOpportunityStatus(
                id: opportunity.id,
                status: .new
            )
            ignoredOpportunities.removeAll { $0.id == opportunity.id }
            newOpportunities.append(updated)
        } catch {
            self.error = error.localizedDescription
            handleAuthError(error)
        }
    }

    func deleteOpportunity(_ opportunity: Opportunity) async {
        do {
            try await apiService.deleteOpportunity(id: opportunity.id)
            newOpportunities.removeAll { $0.id == opportunity.id }
            validatedOpportunities.removeAll { $0.id == opportunity.id }
            ignoredOpportunities.removeAll { $0.id == opportunity.id }
        } catch {
            self.error = error.localizedDescription
            handleAuthError(error)
        }
    }
}
