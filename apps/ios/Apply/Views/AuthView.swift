//
//  AuthView.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case otp
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue.gradient)
                
                Text(viewModel.showOTPView ? "Vérification" : "Connexion")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(viewModel.showOTPView 
                     ? "Entrez le code reçu par email" 
                     : "Entrez votre email pour continuer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Form
            VStack(spacing: 24) {
                if !viewModel.showOTPView {
                    // Email Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        TextField("votre@email.com", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .email)
                            .submitLabel(.send)
                            .onSubmit {
                                Task {
                                    await viewModel.sendOTP()
                                }
                            }
                    }
                    
                    // Send OTP Button
                    Button {
                        Task {
                            await viewModel.sendOTP()
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            } else {
                                Text("Envoyer le code")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading || viewModel.email.isEmpty)
                } else {
                    // OTP Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Code de vérification")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        TextField("000000", text: $viewModel.otpCode)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .otp)
                            .onChange(of: viewModel.otpCode) { oldValue, newValue in
                                // Limiter à 6 chiffres
                                if newValue.count > 6 {
                                    viewModel.otpCode = String(newValue.prefix(6))
                                }
                            }
                        
                        Text("Code envoyé à \(viewModel.email)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    
                    // Verify OTP Button
                    Button {
                        Task {
                            await viewModel.verifyOTP()
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            } else {
                                Text("Vérifier")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading || viewModel.otpCode.count != 6)
                    
                    // Back button
                    Button {
                        viewModel.showOTPView = false
                        viewModel.otpCode = ""
                        viewModel.errorMessage = nil
                    } label: {
                        Text("Changer d'email")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                    .padding(.top, 8)
                }
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            focusedField = viewModel.showOTPView ? .otp : .email
        }
        .onChange(of: viewModel.showOTPView) { oldValue, newValue in
            focusedField = newValue ? .otp : .email
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
