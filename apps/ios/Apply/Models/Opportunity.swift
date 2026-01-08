import Foundation

enum Priority: String, Codable {
    case A
    case B
    case C
}

enum OpportunityStatus: String, Codable {
    case new
    case validated
    case applied
    case ignored
}

struct Opportunity: Identifiable, Codable, Hashable {
    let id: String
    let company: String
    let role: String
    let location: String?
    let priority: Priority
    var status: OpportunityStatus
    let url: String?
    let source: String?
    let notes: String?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, company, role, location, priority, status, url, source, notes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
