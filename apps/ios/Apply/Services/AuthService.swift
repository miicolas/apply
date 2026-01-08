//
//  AuthService.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    private let baseURL = "http://localhost:3000" // TODO: Remplacer par la variable d'environnement
    
    private init() {}
    
    /// Envoie un code OTP à l'email fourni
    func sendOTP(email: String) async throws {
        guard let url = URL(string: "\(baseURL)/api/auth/send-otp") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.serverError(httpResponse.statusCode)
        }
    }
    
    /// Vérifie le code OTP et crée une session
    func verifyOTP(email: String, code: String) async throws -> AuthSession {
        guard let url = URL(string: "\(baseURL)/api/auth/verify-otp") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "code": code]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw AuthError.invalidOTP
            }
            throw AuthError.serverError(httpResponse.statusCode)
        }
        
        // Extraire le token de session depuis les cookies ou le body
        let decoder = JSONDecoder()
        let authResponse = try decoder.decode(AuthResponse.self, from: data)
        
        // Stocker le token dans UserDefaults ou Keychain
        UserDefaults.standard.set(authResponse.sessionToken, forKey: "auth_token")
        
        return AuthSession(token: authResponse.sessionToken, email: email)
    }
    
    /// Vérifie si une session existe
    func checkSession() -> Bool {
        return UserDefaults.standard.string(forKey: "auth_token") != nil
    }
    
    /// Déconnecte l'utilisateur
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "auth_token")
    }
}

struct AuthSession {
    let token: String
    let email: String
}

struct AuthResponse: Codable {
    let sessionToken: String
    
    enum CodingKeys: String, CodingKey {
        case sessionToken = "sessionToken"
    }
}

enum AuthError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidOTP
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalide"
        case .invalidResponse:
            return "Réponse invalide du serveur"
        case .invalidOTP:
            return "Code OTP invalide"
        case .serverError(let code):
            return "Erreur serveur (\(code))"
        }
    }
}
