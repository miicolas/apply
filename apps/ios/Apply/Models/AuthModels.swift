//
//  AuthModels.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

// MARK: - User Model
struct User: Codable {
    let id: String
    let name: String
    let email: String
    let emailVerified: Bool
    let image: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case emailVerified
        case image
        case createdAt
        case updatedAt
    }
}

// MARK: - Session Model
struct Session: Codable {
    let id: String
    let expiresAt: String
    let token: String
    let createdAt: String
    let updatedAt: String
    let ipAddress: String?
    let userAgent: String?
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiresAt
        case token
        case createdAt
        case updatedAt
        case ipAddress
        case userAgent
        case userId
    }
}

// MARK: - Session Response
struct SessionResponse: Codable {
    let user: User
    let session: Session
}

// MARK: - Send OTP Request
struct SendOTPRequest: Codable {
    let email: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
    }
}

// MARK: - Sign In OTP Request
struct SignInOTPRequest: Codable {
    let email: String
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case otp
    }
}

// MARK: - Auth Session (for internal use)
struct AuthSession {
    let user: User
    let session: Session
}
