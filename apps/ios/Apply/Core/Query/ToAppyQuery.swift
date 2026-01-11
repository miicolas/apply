//
//  ToAppyQuery.swift
//  Apply
//

import Foundation

// MARK: - Shared Network Client

let networkClient: NetworkClient = APINetworkClient(baseURL: APIConfig.baseURL)

// MARK: - Job Offers

func getAllJobOffers() async throws -> [JobOffer] {
    let endpoint = Endpoint("/job-offers")
    return try await networkClient.request(endpoint, method: .GET, body: nil)
}

func getJobOffer(id: String) async throws -> JobOffer {
    let endpoint = Endpoint("/job-offers/\(id)")
    return try await networkClient.request(endpoint, method: .GET, body: nil)
}

// MARK: - Applications

func getAllApplications() async throws -> [Application] {
    let endpoint = Endpoint("/applications")
    return try await networkClient.request(endpoint, method: .GET, body: nil)
}

func getApplication(id: String) async throws -> Application {
    let endpoint = Endpoint("/applications/\(id)")
    return try await networkClient.request(endpoint, method: .GET, body: nil)
}

func updateApplicationStatus(id: String, status: ApplicationStatus) async throws -> Application {
    let endpoint = Endpoint("/applications/\(id)/status")
    let body = try JSONEncoder().encode(["status": status.rawValue])
    return try await networkClient.request(endpoint, method: .PUT, body: body)
}
