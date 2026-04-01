//
//  HealthcareFacilitySignUpView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-02-18.
//

import SwiftUI

struct HealthcareFacilitySignUpView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userType") private var storedUserType = ""
    
    @State private var facilityName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var facilityType = ""
    @State private var description = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var navigateToDashboard = false
    
    let facilityTypes = [
        "Hospital",
        "Clinic",
        "Nursing Home",
        "Assisted Living",
        "Home Health",
        "Urgent Care",
        "Rehabilitation Center",
        "Other"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Healthcare Facility Sign Up")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex: "333333"))
                        
                        Text("Connect with qualified healthcare professionals")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "666666"))
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Facility Name
                        FormField(label: "Facility Name", text: $facilityName, placeholder: "Memorial Hospital")
                        
                        // Email
                        FormField(label: "Email Address", text: $email, placeholder: "contact@facility.com", keyboardType: .emailAddress)
                        
                        // Phone
                        FormField(label: "Phone Number", text: $phone, placeholder: "(555) 123-4567", keyboardType: .phonePad)
                        
                        // Facility Type Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Facility Type *")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "333333"))
                            
                            Picker("Select facility type", selection: $facilityType) {
                                Text("Select your facility type").tag("")
                                ForEach(facilityTypes, id: \.self) { type in
                                    Text(type).tag(type)
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
                        
                        // Address
                        FormField(label: "Street Address", text: $address, placeholder: "123 Main Street")
                        
                        // City and State
                        HStack(spacing: 12) {
                            FormField(label: "City", text: $city, placeholder: "Boston")
                            FormField(label: "State", text: $state, placeholder: "MA")
                                .onChange(of: state) { _, newValue in
                                    state = newValue.uppercased().prefix(2).description
                                }
                        }
                        
                        // Zip Code
                        FormField(label: "Zip Code", text: $zipCode, placeholder: "02101", keyboardType: .numberPad)
                        
                        // Description (optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "333333"))
                            
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                                )
                        }
                        
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
                FacilityDashboardView()
            }
        }
    }
    
    func handleSignUp() {
        // Validate input
        if let errorMessage = validateInput() {
            alertMessage = errorMessage
            showAlert = true
            return
        }
        
        isLoading = true
        
        // Call the API
        Task {
            do {
                let response = try await APIService.shared.facilitySignUp(
                    name: facilityName,
                    email: email,
                    password: password,
                    address: address,
                    city: city,
                    state: state,
                    zipCode: zipCode,
                    phoneNumber: phone.isEmpty ? nil : phone,
                    facilityType: facilityType,
                    description: description.isEmpty ? nil : description
                )
                
                // Store auth token and facility data securely
                UserDefaults.standard.set(response.token, forKey: "authToken")
                UserDefaults.standard.set(response.facility.id, forKey: "facilityId")
                UserDefaults.standard.set(response.facility.email, forKey: "facilityEmail")
                UserDefaults.standard.set(response.facility.name, forKey: "facilityName")
                UserDefaults.standard.set(response.facility.facilityType, forKey: "facilityType")
                UserDefaults.standard.set(response.facility.city, forKey: "facilityCity")
                UserDefaults.standard.set(response.facility.state, forKey: "facilityState")
                UserDefaults.standard.set(response.facility.address, forKey: "facilityAddress")
                UserDefaults.standard.set(response.facility.zipCode, forKey: "facilityZipCode")
                if let phone = response.facility.phoneNumber {
                    UserDefaults.standard.set(phone, forKey: "facilityPhone")
                }
                if let desc = response.facility.description {
                    UserDefaults.standard.set(desc, forKey: "facilityDescription")
                }
                UserDefaults.standard.set("facility", forKey: "userType")
                
                await MainActor.run {
                    isLoading = false
                    storedUserType = "facility"
                    isLoggedIn = true
                    alertMessage = "Account created successfully! Welcome to Yolku, \(response.facility.name)!"
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
    
    private func validateInput() -> String? {
        // Check required fields
        if facilityName.isEmpty {
            return "Please enter a facility name"
        }
        if email.isEmpty {
            return "Please enter an email address"
        }
        if address.isEmpty {
            return "Please enter a street address"
        }
        if city.isEmpty {
            return "Please enter a city"
        }
        if state.isEmpty {
            return "Please enter a state"
        }
        if state.count != 2 {
            return "Please enter a valid 2-letter state code"
        }
        if zipCode.isEmpty {
            return "Please enter a zip code"
        }
        if facilityType.isEmpty {
            return "Please select a facility type"
        }
        if password.isEmpty {
            return "Please enter a password"
        }
        if password.count < 8 {
            return "Password must be at least 8 characters long"
        }
        if password != confirmPassword {
            return "Passwords do not match"
        }
        if !agreeToTerms {
            return "Please agree to the Terms of Service and Privacy Policy"
        }
        
        return nil
    }
}

#Preview {
    HealthcareFacilitySignUpView()
}
