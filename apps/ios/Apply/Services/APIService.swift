//
//  APIService.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

class APIService {
    static let shared = APIService()

    private let networkClient: NetworkClient
    private let encoder: JSONEncoder

    private init() {
        self.networkClient = APINetworkClient(baseURL: APIConfig.baseURL)

        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder = jsonEncoder
    }

    // MARK: - Queries

    func getOpportunities(status: OpportunityStatus? = nil) async throws -> [Opportunity] {
        let queryItems = status.map { [URLQueryItem(name: "status", value: $0.rawValue)] }
        let endpoint = Endpoint("/opportunities", queryItems: queryItems)
        let response: OpportunitiesResponse = try await networkClient.request(endpoint, method: .GET, body: nil)
        return response.opportunities
    }

    func getOpportunity(id: String) async throws -> Opportunity {
        let endpoint = Endpoint("/opportunities/\(id)")
        let response: OpportunityResponse = try await networkClient.request(endpoint, method: .GET, body: nil)
        return response.opportunity
    }

    // MARK: - Mutations

    func createOpportunity(_ request: CreateOpportunityRequest) async throws -> Opportunity {
        let body = try encoder.encode(request)
        let endpoint = Endpoint("/opportunities")
        let response: OpportunityResponse = try await networkClient.request(endpoint, method: .POST, body: body)
        return response.opportunity
    }

    func updateOpportunityStatus(id: String, status: OpportunityStatus) async throws -> Opportunity {
        let request = UpdateStatusRequest(status: status)
        let body = try encoder.encode(request)
        let endpoint = Endpoint("/opportunities/\(id)/status")
        let response: OpportunityResponse = try await networkClient.request(endpoint, method: .PUT, body: body)
        return response.opportunity
    }

    func deleteOpportunity(id: String) async throws {
        let endpoint = Endpoint("/opportunities/\(id)")
        let _: SuccessResponse = try await networkClient.request(endpoint, method: .DELETE, body: nil)
    }
}

struct SuccessResponse: Codable {
    let success: Bool
}
