//
//  SignInView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var navigateToDashboard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()
                            .frame(height: 40)
                        
                        // Logo
                        Text("Yolku")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white, Color.white.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        // Sign in container
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 8) {
                                Text("Welcome Back")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color(hex: "333333"))
                                
                                Text("Sign in to your account")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "666666"))
                            }
                            .padding(.top, 32)
                            
                            // Form
                            VStack(spacing: 20) {
                                // Email
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email Address")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(hex: "333333"))
                                    
                                    TextField("you@example.com", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .padding()
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                                        )
                                }
                                
                                // Password
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(hex: "333333"))
                                    
                                    SecureField("Enter your password", text: $password)
                                        .padding()
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                                        )
                                }
                                
                                // Forgot Password
                                HStack {
                                    Spacer()
                                    Button("Forgot password?") {
                                        // Forgot password action
                                    }
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "667eea"))
                                }
                            }
                            .padding(.horizontal, 32)
                            
                            // Sign In Button
                            Button(action: handleSignIn) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 18, weight: .semibold))
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
                            .disabled(isLoading)
                            .padding(.horizontal, 32)
                            .padding(.top, 10)
                            
                            // Divider
                            HStack {
                                Rectangle()
                                    .fill(Color(hex: "e0e0e0"))
                                    .frame(height: 1)
                                Text("OR")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "999999"))
                                Rectangle()
                                    .fill(Color(hex: "e0e0e0"))
                                    .frame(height: 1)
                            }
                            .padding(.horizontal, 32)
                            
                            // Sign Up Link
                            HStack {
                                Text("Don't have an account?")
                                    .foregroundColor(Color(hex: "666666"))
                                Button("Sign Up") {
                                    // Navigate to sign up
                                }
                                .foregroundColor(Color(hex: "667eea"))
                                .fontWeight(.semibold)
                            }
                            .font(.system(size: 15))
                            
                            // Back Home
                            Button("← Back to Home") {
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
            .alert("Sign In", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    if alertMessage.contains("successful") {
                        navigateToDashboard = true
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .fullScreenCover(isPresented: $navigateToDashboard) {
                DashboardView()
            }
        }
    }
    
    func handleSignIn() {
        // Validation
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        
        // Basic email validation
        if !email.contains("@") || !email.contains(".") {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        isLoading = true
        
        // Call the API
        Task {
            do {
                let response = try await APIService.shared.signIn(
                    email: email,
                    password: password
                )
                
                // Store auth token and user data securely
                UserDefaults.standard.set(response.token, forKey: "authToken")
                UserDefaults.standard.set(response.user.email, forKey: "userEmail")
                UserDefaults.standard.set(response.user.firstName, forKey: "userFirstName")
                UserDefaults.standard.set(response.user.profession ?? "Healthcare Professional", forKey: "userProfession")
                
                await MainActor.run {
                    isLoading = false
                    isLoggedIn = true
                    alertMessage = "Sign in successful! Welcome back, \(response.user.firstName)!"
                    showAlert = true
                }
            } catch let error as APIError {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = "Network error. Please check your connection and try again."
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
