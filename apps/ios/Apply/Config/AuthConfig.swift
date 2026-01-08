//
//  AuthConfig.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct AuthConfig {
    static var baseURL: URL {
        // Priorité 1: Info.plist
        if let configURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
           let url = URL(string: configURL) {
            return url
        }
        
        // Priorité 2: Variable d'environnement (pour les tests)
        if let envURL = ProcessInfo.processInfo.environment["API_BASE_URL"],
           let url = URL(string: envURL) {
            return url
        }
        
        // Défaut: localhost pour le simulateur
        return URL(string: "http://localhost:3000")!
    }
}
