//
//  AuthService.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation
import Security
import Combine

// MARK: - Auth Models

struct AuthUser: Codable {
    let id: String
    let email: String
    let name: String
    let image: String?
}

struct SignUpRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct SignInRequest: Codable {
    let email: String
    let password: String
}

// Better Auth sign-in/sign-up response format: {token, user}
struct BetterAuthResponse: Codable {
    let token: String
    let user: AuthUser
}

// Better Auth get-session response format: {session, user}
struct SessionResponse: Codable {
    let session: SessionInfo
    let user: AuthUser

    struct SessionInfo: Codable {
        let id: String
        let token: String
        let expiresAt: String
        let createdAt: String?
        let updatedAt: String?
        let ipAddress: String?
        let userAgent: String?
        let userId: String?
    }
}

struct APIErrorResponse: Codable {
    let error: String?
    let message: String?
}

// MARK: - Token Storage

final class TokenStorage {
    static let shared = TokenStorage()

    private let tokenKey = "com.apply.auth.token"
    private let userKey = "com.apply.auth.user"

    private init() {}

    var token: String? {
        get { getString(forKey: tokenKey) }
        set {
            if let value = newValue {
                setString(value, forKey: tokenKey)
            } else {
                delete(forKey: tokenKey)
            }
        }
    }

    var user: AuthUser? {
        get {
            guard let data = getData(forKey: userKey) else { return nil }
            return try? JSONDecoder().decode(AuthUser.self, from: data)
        }
        set {
            if let value = newValue, let data = try? JSONEncoder().encode(value) {
                setData(data, forKey: userKey)
            } else {
                delete(forKey: userKey)
            }
        }
    }

    func clear() {
        token = nil
        user = nil
    }

    // MARK: - Keychain Helpers

    private func setString(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        setData(data, forKey: key)
    }

    private func getString(forKey key: String) -> String? {
        guard let data = getData(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func setData(_ data: Data, forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private func getData(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Auth Service

@MainActor
final class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published private(set) var isAuthenticated = false
    @Published private(set) var currentUser: AuthUser?

    private let baseURL: URL
    private let decoder: JSONDecoder

    private init() {
        self.baseURL = APIConfig.baseURL
        
        print("🔧 [AuthService] Initialisé avec baseURL: \(baseURL.absoluteString)")

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = jsonDecoder

        // Restore session on init
        if let user = TokenStorage.shared.user, TokenStorage.shared.token != nil {
            self.currentUser = user
            self.isAuthenticated = true
            print("✅ [AuthService] Session restaurée pour l'utilisateur: \(user.email)")
        }
    }

    var token: String? {
        TokenStorage.shared.token
    }

    // MARK: - Sign Up

    func signUp(name: String, email: String, password: String) async throws {
        let url = baseURL.appendingPathComponent("/api/auth/sign-up/email")
        print("📤 [AuthService] SignUp - URL: \(url.absoluteString)")
        print("📤 [AuthService] SignUp - Email: \(email)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SignUpRequest(name: name, email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        print("📤 [AuthService] SignUp - Envoi de la requête...")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
            print("📥 [AuthService] SignUp - Réponse reçue")
        } catch {
            print("❌ [AuthService] SignUp - Erreur réseau: \(error)")
            print("❌ [AuthService] SignUp - Type d'erreur: \(type(of: error))")
            if let urlError = error as? URLError {
                print("❌ [AuthService] SignUp - URLError code: \(urlError.code.rawValue)")
                print("❌ [AuthService] SignUp - URLError description: \(urlError.localizedDescription)")
                if let failureURL = urlError.failingURL {
                    print("❌ [AuthService] SignUp - URLError failureURL: \(failureURL)")
                }
                switch urlError.code {
                case .notConnectedToInternet:
                    throw AuthError.serverError("Pas de connexion Internet")
                case .cannotConnectToHost, .cannotFindHost:
                    throw AuthError.serverError("Impossible de se connecter au serveur. Vérifiez que le serveur est démarré sur \(baseURL.absoluteString)")
                case .timedOut:
                    throw AuthError.serverError("Connexion au serveur expirée")
                default:
                    throw AuthError.serverError("Erreur réseau: \(urlError.localizedDescription)")
                }
            }
            throw AuthError.serverError("Erreur réseau: \(error.localizedDescription)")
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [AuthService] SignUp - Réponse HTTP invalide")
            throw AuthError.invalidResponse
        }
        
        print("📥 [AuthService] SignUp - Status code: \(httpResponse.statusCode)")
        print("📥 [AuthService] SignUp - Headers: \(httpResponse.allHeaderFields)")

        // Extract bearer token from response header
        if let authToken = httpResponse.value(forHTTPHeaderField: "set-auth-token") {
            TokenStorage.shared.token = authToken
            print("✅ [AuthService] SignUp - Token reçu dans le header")
        }

        guard httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Impossible de lire le body"
            print("❌ [AuthService] SignUp - Erreur serveur (\(httpResponse.statusCode)): \(errorBody)")
            let errorMessage = try? decoder.decode(APIErrorResponse.self, from: data)
            throw AuthError.serverError(errorMessage?.error ?? errorMessage?.message ?? "Échec de l'inscription")
        }

        let responseBody = String(data: data, encoding: .utf8) ?? "Impossible de lire le body"
        print("📥 [AuthService] SignUp - Body: \(responseBody)")
        
        let authResponse: BetterAuthResponse
        do {
            authResponse = try decoder.decode(BetterAuthResponse.self, from: data)
        } catch {
            print("❌ [AuthService] SignUp - Erreur de décodage: \(error)")
            throw AuthError.serverError("Erreur de décodage de la réponse")
        }

        // Store token if not from header (fallback to response body)
        if TokenStorage.shared.token == nil {
            TokenStorage.shared.token = authResponse.token
            print("✅ [AuthService] SignUp - Token stocké depuis le body")
        }

        TokenStorage.shared.user = authResponse.user
        currentUser = authResponse.user
        isAuthenticated = true
        print("✅ [AuthService] SignUp - Inscription réussie pour: \(authResponse.user.email)")
    }

    // MARK: - Sign In

    func signIn(email: String, password: String) async throws {
        let url = baseURL.appendingPathComponent("/api/auth/sign-in/email")
        print("📤 [AuthService] SignIn - URL: \(url.absoluteString)")
        print("📤 [AuthService] SignIn - Email: \(email)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SignInRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        print("📤 [AuthService] SignIn - Envoi de la requête...")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
            print("📥 [AuthService] SignIn - Réponse reçue")
        } catch {
            print("❌ [AuthService] SignIn - Erreur réseau: \(error)")
            print("❌ [AuthService] SignIn - Type d'erreur: \(type(of: error))")
            if let urlError = error as? URLError {
                print("❌ [AuthService] SignIn - URLError code: \(urlError.code.rawValue)")
                print("❌ [AuthService] SignIn - URLError description: \(urlError.localizedDescription)")
                if let failureURL = urlError.failingURL {
                    print("❌ [AuthService] SignIn - URLError failureURL: \(failureURL)")
                }
                switch urlError.code {
                case .notConnectedToInternet:
                    throw AuthError.serverError("Pas de connexion Internet")
                case .cannotConnectToHost, .cannotFindHost:
                    throw AuthError.serverError("Impossible de se connecter au serveur. Vérifiez que le serveur est démarré sur \(baseURL.absoluteString)")
                case .timedOut:
                    throw AuthError.serverError("Connexion au serveur expirée")
                default:
                    throw AuthError.serverError("Erreur réseau: \(urlError.localizedDescription)")
                }
            }
            throw AuthError.serverError("Erreur réseau: \(error.localizedDescription)")
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [AuthService] SignIn - Réponse HTTP invalide")
            throw AuthError.invalidResponse
        }
        
        print("📥 [AuthService] SignIn - Status code: \(httpResponse.statusCode)")
        print("📥 [AuthService] SignIn - Headers: \(httpResponse.allHeaderFields)")

        // Extract bearer token from response header
        if let authToken = httpResponse.value(forHTTPHeaderField: "set-auth-token") {
            TokenStorage.shared.token = authToken
            print("✅ [AuthService] SignIn - Token reçu dans le header")
        }

        guard httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Impossible de lire le body"
            print("❌ [AuthService] SignIn - Erreur serveur (\(httpResponse.statusCode)): \(errorBody)")
            let errorMessage = try? decoder.decode(APIErrorResponse.self, from: data)
            throw AuthError.serverError(errorMessage?.error ?? errorMessage?.message ?? "Email ou mot de passe incorrect")
        }

        let responseBody = String(data: data, encoding: .utf8) ?? "Impossible de lire le body"
        print("📥 [AuthService] SignIn - Body: \(responseBody)")
        
        let authResponse: BetterAuthResponse
        do {
            authResponse = try decoder.decode(BetterAuthResponse.self, from: data)
        } catch {
            print("❌ [AuthService] SignIn - Erreur de décodage: \(error)")
            throw AuthError.serverError("Erreur de décodage de la réponse")
        }

        // Store token if not from header (fallback to response body)
        if TokenStorage.shared.token == nil {
            TokenStorage.shared.token = authResponse.token
            print("✅ [AuthService] SignIn - Token stocké depuis le body")
        }

        TokenStorage.shared.user = authResponse.user
        currentUser = authResponse.user
        isAuthenticated = true
        print("✅ [AuthService] SignIn - Connexion réussie pour: \(authResponse.user.email)")
    }

    // MARK: - Session

    func refreshSession() async {
        guard let token = TokenStorage.shared.token else {
            await signOutLocally()
            return
        }

        let url = baseURL.appendingPathComponent("/api/auth/get-session")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                await signOutLocally()
                return
            }

            let sessionResponse = try decoder.decode(SessionResponse.self, from: data)
            // Update token from session (in case it was refreshed)
            TokenStorage.shared.token = sessionResponse.session.token
            TokenStorage.shared.user = sessionResponse.user
            currentUser = sessionResponse.user
            isAuthenticated = true
        } catch {
            await signOutLocally()
        }
    }

    // MARK: - Sign Out

    func signOut() async {
        guard let token = TokenStorage.shared.token else {
            await signOutLocally()
            return
        }

        let url = baseURL.appendingPathComponent("/api/auth/sign-out")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Fire and forget - always sign out locally regardless of server response
        _ = try? await URLSession.shared.data(for: request)

        await signOutLocally()
    }

    private func signOutLocally() async {
        TokenStorage.shared.clear()
        currentUser = nil
        isAuthenticated = false
    }
}

// MARK: - Errors

enum AuthError: LocalizedError {
    case invalidResponse
    case serverError(String)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Réponse serveur invalide"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Session expirée"
        }
    }
}

