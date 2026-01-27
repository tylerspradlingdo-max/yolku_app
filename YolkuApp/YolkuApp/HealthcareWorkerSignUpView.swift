//
//  HealthcareWorkerSignUpView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct HealthcareWorkerSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var profession = ""
    @State private var license = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var navigateToDashboard = false
    
    let professions = [
        "Registered Nurse (RN)",
        "Licensed Practical Nurse (LPN)",
        "Certified Nursing Assistant (CNA)",
        "Physician/Doctor",
        "Physician Assistant (PA)",
        "Nurse Practitioner (NP)",
        "Physical/Occupational Therapist",
        "Other Healthcare Professional"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Healthcare Worker Sign Up")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex: "333333"))
                        
                        Text("Join thousands of medical professionals")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "666666"))
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Name Fields
                        HStack(spacing: 12) {
                            FormField(label: "First Name", text: $firstName, placeholder: "John")
                            FormField(label: "Last Name", text: $lastName, placeholder: "Doe")
                        }
                        
                        // Email
                        FormField(label: "Email Address", text: $email, placeholder: "john.doe@email.com", keyboardType: .emailAddress)
                        
                        // Phone
                        FormField(label: "Phone Number", text: $phone, placeholder: "(555) 123-4567", keyboardType: .phonePad)
                        
                        // Profession Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Profession *")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "333333"))
                            
                            Picker("Select profession", selection: $profession) {
                                Text("Select your profession").tag("")
                                ForEach(professions, id: \.self) { profession in
                                    Text(profession).tag(profession)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                            )
                        }
                        
                        // License Number
                        FormField(label: "License Number", text: $license, placeholder: "ABC123456")
                        
                        // Password
                        SecureFormField(label: "Password", text: $password, placeholder: "Enter password")
                        
                        // Confirm Password
                        SecureFormField(label: "Confirm Password", text: $confirmPassword, placeholder: "Confirm password")
                        
                        // Terms Checkbox
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: {
                                agreeToTerms.toggle()
                            }) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(agreeToTerms ? Color(hex: "667eea") : Color(hex: "999999"))
                                    .font(.system(size: 24))
                            }
                            
                            Text("I agree to the Terms of Service and Privacy Policy")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "666666"))
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    
                    // Submit Button
                    Button(action: handleSignUp) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        } else {
                            Text("Create Account")
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
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Sign In Link
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(Color(hex: "666666"))
                        Button("Sign In") {
                            dismiss()
                        }
                        .foregroundColor(Color(hex: "667eea"))
                        .fontWeight(.semibold)
                    }
                    .font(.system(size: 15))
                    .padding(.bottom, 30)
                }
            }
            .background(Color(hex: "f8f9fa"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Yolku")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "667eea"))
                }
            }
            .alert("Sign Up", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    if alertMessage.contains("success") {
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
    
    func handleSignUp() {
        // Validation
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || phone.isEmpty || profession.isEmpty || license.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all required fields"
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords do not match!"
            showAlert = true
            return
        }
        
        if password.count < 8 {
            alertMessage = "Password must be at least 8 characters long"
            showAlert = true
            return
        }
        
        if !agreeToTerms {
            alertMessage = "Please agree to the Terms of Service and Privacy Policy"
            showAlert = true
            return
        }
        
        isLoading = true
        
        // Extract profession abbreviation for API (e.g., "RN" from "Registered Nurse (RN)")
        let professionCode: String
        if profession.contains("(") && profession.contains(")") {
            let start = profession.firstIndex(of: "(")!
            let end = profession.firstIndex(of: ")")!
            professionCode = String(profession[profession.index(after: start)..<end])
        } else if profession.contains("Doctor") || profession.contains("Physician") {
            professionCode = "Doctor"
        } else if profession.contains("Therapist") {
            professionCode = "Therapist"
        } else {
            professionCode = "Other"
        }
        
        // Call the API
        Task {
            do {
                let response = try await APIService.shared.signUp(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password,
                    phoneNumber: phone.isEmpty ? nil : phone,
                    profession: professionCode,
                    licenseNumber: license.isEmpty ? nil : license
                )
                
                // Store auth token and user data securely
                UserDefaults.standard.set(response.token, forKey: "authToken")
                UserDefaults.standard.set(response.user.email, forKey: "userEmail")
                UserDefaults.standard.set(response.user.firstName, forKey: "userFirstName")
                UserDefaults.standard.set(response.user.profession ?? profession, forKey: "userProfession")
                
                await MainActor.run {
                    isLoading = false
                    isLoggedIn = true
                    alertMessage = "Account created successfully! Welcome to Yolku, \(response.user.firstName)!"
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

struct FormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(label) *")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "333333"))
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                )
        }
    }
}

struct SecureFormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(label) *")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "333333"))
            
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                )
        }
    }
}

#Preview {
    HealthcareWorkerSignUpView()
}
