import Foundation

enum APIError: LocalizedError {
    case unauthorized
    case notFound
    case validationError(String)
    case serverError(String)
    case networkError(Error)
    case decodingError
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Vous devez être connecté"
        case .notFound:
            return "Ressource non trouvée"
        case .validationError(let message):
            return "Erreur de validation: \(message)"
        case .serverError(let message):
            return "Erreur serveur: \(message)"
        case .networkError(let error):
            return "Erreur réseau: \(error.localizedDescription)"
        case .decodingError:
            return "Erreur de décodage des données"
        case .invalidURL:
            return "URL invalide"
        }
    }
}
