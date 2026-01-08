import Foundation

struct AuthConfig {
    static var baseURL: URL {
        if let configURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
           let url = URL(string: configURL) {
            return url
        }
        
        if let envURL = ProcessInfo.processInfo.environment["API_BASE_URL"],
           let url = URL(string: envURL) {
            return url
        }
        
        return URL(string: "http://localhost:3000")!
    }
}
