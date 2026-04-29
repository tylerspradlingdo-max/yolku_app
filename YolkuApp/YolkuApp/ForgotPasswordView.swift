//
//  ForgotPasswordView.swift
//  YolkuApp
//
//  Allows users to request a password reset email.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var didSend = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer().frame(height: 40)

                        Text("Yolku")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)

                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Image(systemName: "lock.rotation")
                                    .font(.system(size: 44))
                                    .foregroundColor(Color(hex: "667eea"))
                                    .padding(.top, 32)

                                Text("Forgot Password?")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(Color(hex: "333333"))

                                Text("Enter your email address and we'll send you a link to reset your password.")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(hex: "666666"))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                            }

                            if !didSend {
                                VStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Email Address")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(hex: "333333"))

                                        TextField("you@example.com", text: $email)
                                            .keyboardType(.emailAddress)
                                            .textInputAutocapitalization(.never)
                                            .padding()
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                                            )
                                    }

                                    Button(action: handleSubmit) {
                                        if isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 16)
                                        } else {
                                            Text("Send Reset Link")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 16)
                                        }
                                    }
                                    .background(
                                        LinearGradient(
                                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .disabled(isLoading || email.isEmpty)
                                }
                                .padding(.horizontal, 32)
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(.green)

                                    Text("Check your inbox")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color(hex: "333333"))

                                    Text("If an account with that email exists, you'll receive a password reset link shortly.")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "666666"))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 16)
                                }
                                .padding(.horizontal, 24)
                            }

                            Button("← Back to Sign In") {
                                dismiss()
                            }
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "999999"))
                            .padding(.bottom, 32)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func handleSubmit() {
        guard !email.isEmpty else { return }
        guard email.contains("@") && email.contains(".") else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

        isLoading = true
        Task {
            do {
                try await APIService.shared.forgotPassword(email: email)
                await MainActor.run {
                    isLoading = false
                    didSend = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = "Something went wrong. Please check your connection and try again."
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
