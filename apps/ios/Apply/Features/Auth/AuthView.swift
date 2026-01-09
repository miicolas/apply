//
//  AuthView.swift
//  Apply
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case name
        case email
        case password
    }

    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue.gradient)

                Text(viewModel.isSignUpMode ? "Inscription" : "Connexion")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(viewModel.isSignUpMode
                     ? "Créez votre compte"
                     : "Connectez-vous à votre compte")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)

            Spacer()

            // Form
            VStack(spacing: 16) {
                // Name field (sign up only)
                if viewModel.isSignUpMode {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nom")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)

                        TextField("Votre nom", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.name)
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .name)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                    }
                }

                // Email field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    TextField("votre@email.com", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }
                }

                // Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mot de passe")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    SecureField("••••••••", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(viewModel.isSignUpMode ? .newPassword : .password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            Task {
                                if viewModel.isSignUpMode {
                                    await viewModel.signUp()
                                } else {
                                    await viewModel.signIn()
                                }
                            }
                        }

                    if viewModel.isSignUpMode {
                        Text("Minimum 8 caractères")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // Error message
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Submit button
                Button {
                    Task {
                        if viewModel.isSignUpMode {
                            await viewModel.signUp()
                        } else {
                            await viewModel.signIn()
                        }
                    }
                } label: {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Text(viewModel.isSignUpMode ? "S'inscrire" : "Se connecter")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading || !viewModel.isFormValid)

                // Toggle mode button
                Button {
                    viewModel.toggleMode()
                } label: {
                    Text(viewModel.isSignUpMode
                         ? "Déjà un compte ? Se connecter"
                         : "Pas de compte ? S'inscrire")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            focusedField = viewModel.isSignUpMode ? .name : .email
        }
        .onChange(of: viewModel.isSignUpMode) { _, isSignUp in
            focusedField = isSignUp ? .name : .email
        }
    }
}

#Preview {
    AuthView()
}
