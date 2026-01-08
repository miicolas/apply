import Foundation

enum Priority: String {
    case A
    case B
    case C
}

enum OpportunityStatus: String {
    case new
    case validated
    case ignored
}

struct Opportunity: Identifiable {
    let id = UUID()
    let company: String
    let role: String
    let location: String
    let priority: Priority
    var status: OpportunityStatus
    let url: String
    let source: String
}
