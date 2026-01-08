import SwiftUI
import BetterAuth
import BetterAuthEmailOTP

struct AuthView: View {
    @EnvironmentObject var authClient: BetterAuthClient
    @FocusState private var focusedField: Field?
    @State private var email = ""
    @State private var otpCode = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showOTPView = false
    
    enum Field {
        case email
        case otp
    }
    
    private func sendOTP() async {
        guard !email.isEmpty, isValidEmail(email) else {
            errorMessage = "Veuillez entrer une adresse email valide"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await authClient.emailOtp.sendVerificationOtp(
                with: EmailOTPSendVerificationOTPRequest(email: email, type: .signIn)
            )
            showOTPView = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func verifyOTP() async {
        guard otpCode.count == 6 else {
            errorMessage = "Le code OTP doit contenir 6 chiffres"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await authClient.signIn.emailOtp(
                with: .init(email: email, otp: otpCode)
            )
            
            _ = try await authClient.getSession()
            
            otpCode = ""
            showOTPView = false
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue.gradient)
                
                Text(showOTPView ? "Vérification" : "Connexion")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(showOTPView 
                     ? "Entrez le code reçu par email" 
                     : "Entrez votre email pour continuer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            
            Spacer()
            
            VStack(spacing: 24) {
                if !showOTPView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        TextField("votre@email.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .email)
                            .submitLabel(.send)
                            .onSubmit {
                                Task {
                                    await sendOTP()
                                }
                            }
                    }
                    
                    Button {
                        Task {
                            await sendOTP()
                        }
                    } label: {
                        HStack {
                            if isLoading {
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
                    .disabled(isLoading || email.isEmpty)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Code de vérification")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        TextField("000000", text: $otpCode)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .otp)
                            .onChange(of: otpCode) { oldValue, newValue in
                                if newValue.count > 6 {
                                    otpCode = String(newValue.prefix(6))
                                }
                            }
                        
                        Text("Code envoyé à \(email)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    
                    Button {
                        Task {
                            await verifyOTP()
                        }
                    } label: {
                        HStack {
                            if isLoading {
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
                    .disabled(isLoading || otpCode.count != 6)
                    
                    Button {
                        showOTPView = false
                        otpCode = ""
                        errorMessage = nil
                    } label: {
                        Text("Changer d'email")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                    .padding(.top, 8)
                }
                
                if let errorMessage = errorMessage {
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
            focusedField = showOTPView ? .otp : .email
        }
        .onChange(of: showOTPView) { oldValue, newValue in
            focusedField = newValue ? .otp : .email
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(BetterAuthClient(
            baseURL: AuthConfig.baseURL,
            scheme: "apply",
            plugins: [EmailOTPPlugin()]
        ))
}

