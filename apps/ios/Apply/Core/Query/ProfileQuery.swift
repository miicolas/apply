//
//  ProfileQuery.swift
//  Apply
//

import Foundation

// MARK: - User Preferences

func getUserPreferences() async throws -> UserPreferences? {
    let endpoint = Endpoint("/user-preferences")
    return try await networkClient.request(endpoint, method: .GET, body: nil)
}

func updateUserPreferences(_ request: UpdateUserPreferencesRequest) async throws -> UserPreferences {
    let endpoint = Endpoint("/user-preferences")
    let body = try JSONEncoder().encode(request)
    return try await networkClient.request(endpoint, method: .PUT, body: body)
}

// MARK: - Skills

func getAllSkills() async throws -> [Skill] {
    let endpoint = Endpoint("/user-skills")
    return try await networkClient.request(endpoint, method: .GET, body: nil)
}

func createSkill(_ request: CreateSkillRequest) async throws -> Skill {
    let endpoint = Endpoint("/user-skills")
    let body = try JSONEncoder().encode(request)
    return try await networkClient.request(endpoint, method: .POST, body: body)
}

func updateSkill(id: String, _ request: UpdateSkillRequest) async throws -> Skill {
    let endpoint = Endpoint("/user-skills/\(id)")
    let body = try JSONEncoder().encode(request)
    return try await networkClient.request(endpoint, method: .PUT, body: body)
}

func deleteSkill(id: String) async throws {
    struct EmptyResponse: Decodable {}
    let endpoint = Endpoint("/user-skills/\(id)")
    let _: EmptyResponse = try await networkClient.request(endpoint, method: .DELETE, body: nil)
}

// MARK: - Experiences

func getAllExperiences() async throws -> [Experience] {
    let endpoint = Endpoint("/user-experiences")
    return try await networkClient.request(endpoint, method: .GET, body: nil)
}

func createExperience(_ request: CreateExperienceRequest) async throws -> Experience {
    let endpoint = Endpoint("/user-experiences")
    let body = try JSONEncoder().encode(request)
    return try await networkClient.request(endpoint, method: .POST, body: body)
}

func updateExperience(id: String, _ request: UpdateExperienceRequest) async throws -> Experience {
    let endpoint = Endpoint("/user-experiences/\(id)")
    let body = try JSONEncoder().encode(request)
    return try await networkClient.request(endpoint, method: .PUT, body: body)
}

func deleteExperience(id: String) async throws {
    struct EmptyResponse: Decodable {}
    let endpoint = Endpoint("/user-experiences/\(id)")
    let _: EmptyResponse = try await networkClient.request(endpoint, method: .DELETE, body: nil)
}
