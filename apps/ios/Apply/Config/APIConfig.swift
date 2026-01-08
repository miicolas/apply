//
//  APIConfig.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct APIConfig {
    static var baseURL: URL {
        if let configURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
           let url = URL(string: configURL) {
            return url
        }

        if let envURL = ProcessInfo.processInfo.environment["API_BASE_URL"],
           let url = URL(string: envURL) {
            return url
        }

        // Use 127.0.0.1 instead of localhost for better iOS Simulator compatibility
        // localhost can resolve to IPv6 (::1) which may cause connection issues
        return URL(string: "http://127.0.0.1:3000")!
    }

    static var apiPath: String {
        return "/api"
    }
}
