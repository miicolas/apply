//
//  JobAnalysisService.swift
//  Apply
//
//  Created by Claude on 11/01/2026.
//

import Foundation
import Combine

// MARK: - Models

struct TriggerJobResponse: Codable {
    let success: Bool
    let runId: String
}

struct JobStatusResponse: Codable {
    let status: String
    let metadata: JobMetadata?
    let output: JobAnalysisOutput?
    let error: String?
}

struct JobMetadata: Codable {
    let progress: Double?
    let status: String?
    let step: String?
}

struct JobAnalysisOutput: Codable {
    let status: String
    let jobOfferId: String
    let message: String?
    let jobOffer: JobOfferSummary?
}

struct JobOfferSummary: Codable {
    let id: String
    let title: String
    let companyId: String
    let companyName: String?
    let category: String?
    let description: String?
    let requiredSkills: [String]?
    let location: String?
    let contractType: String?
}

// MARK: - Service

@MainActor
final class JobAnalysisService: ObservableObject {
    @Published private(set) var status: JobAnalysisStatus = .idle
    @Published private(set) var progress: Double = 0
    @Published private(set) var currentStep: String = ""
    @Published private(set) var error: String?
    @Published private(set) var result: JobAnalysisOutput?

    private var pollingTask: Task<Void, Never>?
    private let networkClient: NetworkClient

    enum JobAnalysisStatus: Equatable {
        case idle
        case pending
        case running
        case completed
        case failed
    }

    init(networkClient: NetworkClient = APINetworkClient(baseURL: APIConfig.baseURL)) {
        self.networkClient = networkClient
    }

    func analyzeJobOffer(url: String) async throws {
        status = .pending
        progress = 0
        currentStep = "Démarrage..."
        error = nil
        result = nil

        // 1. Trigger the job
        let requestBody = ["url": url]
        let body = try JSONEncoder().encode(requestBody)

        let response: TriggerJobResponse = try await networkClient.request(
            Endpoint("/jobs/analyze"),
            method: .POST,
            body: body
        )

        // 2. Start polling
        await startPolling(runId: response.runId)
    }

    private func startPolling(runId: String) async {
        pollingTask?.cancel()
        status = .running

        pollingTask = Task {
            var attempts = 0
            let maxAttempts = 90 // 3 minutes max (90 * 2s)

            while !Task.isCancelled && attempts < maxAttempts {
                attempts += 1

                do {
                    let statusResponse: JobStatusResponse = try await networkClient.request(
                        Endpoint("/jobs/\(runId)/status"),
                        method: .GET,
                        body: nil
                    )

                    // Update progress
                    if let metadata = statusResponse.metadata {
                        if let newProgress = metadata.progress {
                            progress = newProgress
                        }
                        if let step = metadata.step {
                            currentStep = step
                        }
                    }

                    // Update status based on Trigger.dev status
                    switch statusResponse.status {
                    case "QUEUED", "PENDING":
                        status = .pending
                    case "EXECUTING":
                        status = .running
                    case "COMPLETED":
                        status = .completed
                        result = statusResponse.output
                        return
                    case "FAILED", "CANCELED", "CRASHED":
                        status = .failed
                        error = statusResponse.error ?? "Une erreur est survenue"
                        return
                    default:
                        break
                    }

                    // Wait 2 seconds before next poll
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                } catch is CancellationError {
                    return
                } catch {
                    self.error = error.localizedDescription
                    status = .failed
                    return
                }
            }

            // Timeout
            if attempts >= maxAttempts {
                error = "L'analyse a pris trop de temps"
                status = .failed
            }
        }

        await pollingTask?.value
    }

    func cancel() {
        pollingTask?.cancel()
        pollingTask = nil
        status = .idle
        progress = 0
        currentStep = ""
        error = nil
        result = nil
    }

    func reset() {
        cancel()
    }
}

