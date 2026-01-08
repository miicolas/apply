//
//  AuthViewModel.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var email = ""
    @Published var otpCode = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showOTPView = false
    
    private let authService = AuthService.shared
    
    init() {
        // Vérifier si une session existe déjà
        isAuthenticated = authService.checkSession()
    }
    
    /// Envoie le code OTP à l'email
    func sendOTP() async {
        guard !email.isEmpty, isValidEmail(email) else {
            errorMessage = "Veuillez entrer une adresse email valide"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.sendOTP(email: email)
            showOTPView = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Vérifie le code OTP
    func verifyOTP() async {
        guard otpCode.count == 6 else {
            errorMessage = "Le code OTP doit contenir 6 chiffres"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await authService.verifyOTP(email: email, code: otpCode)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Déconnecte l'utilisateur
    func signOut() {
        authService.signOut()
        isAuthenticated = false
        email = ""
        otpCode = ""
        showOTPView = false
    }
    
    /// Valide le format de l'email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

