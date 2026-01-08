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
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignUpMode = false

    private let authService = AuthService.shared

    var isFormValid: Bool {
        if isSignUpMode {
            return !name.isEmpty && !email.isEmpty && password.count >= 8
        }
        return !email.isEmpty && !password.isEmpty
    }

    func signIn() async {
        print("🔵 [AuthViewModel] SignIn appelé")
        
        guard !email.isEmpty else {
            print("⚠️ [AuthViewModel] SignIn - Email vide")
            errorMessage = "Veuillez entrer votre email"
            return
        }

        guard !password.isEmpty else {
            print("⚠️ [AuthViewModel] SignIn - Mot de passe vide")
            errorMessage = "Veuillez entrer votre mot de passe"
            return
        }

        isLoading = true
        errorMessage = nil
        print("🔄 [AuthViewModel] SignIn - Début de la connexion...")

        do {
            try await authService.signIn(email: email, password: password)
            print("✅ [AuthViewModel] SignIn - Connexion réussie")
            clearForm()
        } catch {
            print("❌ [AuthViewModel] SignIn - Erreur capturée: \(error)")
            print("❌ [AuthViewModel] SignIn - Description: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        isLoading = false
        print("🏁 [AuthViewModel] SignIn - Terminé")
    }

    func signUp() async {
        print("🔵 [AuthViewModel] SignUp appelé")
        
        guard !name.isEmpty else {
            print("⚠️ [AuthViewModel] SignUp - Nom vide")
            errorMessage = "Veuillez entrer votre nom"
            return
        }

        guard !email.isEmpty else {
            print("⚠️ [AuthViewModel] SignUp - Email vide")
            errorMessage = "Veuillez entrer votre email"
            return
        }

        guard password.count >= 8 else {
            print("⚠️ [AuthViewModel] SignUp - Mot de passe trop court")
            errorMessage = "Le mot de passe doit contenir au moins 8 caractères"
            return
        }

        isLoading = true
        errorMessage = nil
        print("🔄 [AuthViewModel] SignUp - Début de l'inscription...")

        do {
            try await authService.signUp(name: name, email: email, password: password)
            print("✅ [AuthViewModel] SignUp - Inscription réussie")
            clearForm()
        } catch {
            print("❌ [AuthViewModel] SignUp - Erreur capturée: \(error)")
            print("❌ [AuthViewModel] SignUp - Description: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        isLoading = false
        print("🏁 [AuthViewModel] SignUp - Terminé")
    }

    func toggleMode() {
        isSignUpMode.toggle()
        errorMessage = nil
    }

    private func clearForm() {
        name = ""
        email = ""
        password = ""
        errorMessage = nil
    }
}
