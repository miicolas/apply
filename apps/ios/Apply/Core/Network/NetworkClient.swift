//
//  NetworkClient.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

protocol NetworkClient {
    func request<T: Decodable>(_ endpoint: Endpoint, method: HTTPMethod, body: Data?) async throws -> T
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?

    init(_ path: String, queryItems: [URLQueryItem]? = nil) {
        self.path = path
        self.queryItems = queryItems
    }
}

struct APINetworkClient: NetworkClient {
    private let baseURL: URL
    private let decoder: JSONDecoder

    init(baseURL: URL) {
        self.baseURL = baseURL

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        self.decoder = jsonDecoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint, method: HTTPMethod, body: Data? = nil) async throws -> T {
        var urlComponents = URLComponents(string: "\(baseURL)\(APIConfig.apiPath)\(endpoint.path)")
        urlComponents?.queryItems = endpoint.queryItems

        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Get token from TokenStorage
        if let token = TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = body
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.serverError("Invalid response")
            }

            switch httpResponse.statusCode {
            case 200...299:
                return try decoder.decode(T.self, from: data)
            case 401:
                throw APIError.unauthorized
            case 404:
                throw APIError.notFound
            case 400:
                let errorResponse = try? decoder.decode(ErrorResponse.self, from: data)
                throw APIError.validationError(errorResponse?.error ?? "Invalid data")
            default:
                let errorResponse = try? decoder.decode(ErrorResponse.self, from: data)
                throw APIError.serverError(errorResponse?.error ?? "Unknown error")
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
