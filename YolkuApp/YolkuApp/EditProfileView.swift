//
//  EditProfileView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-02-25.
//

import SwiftUI

// MARK: - State License Model
struct StateLicense: Identifiable, Codable {
    let id: UUID
    var state: String
    var licenseNumber: String

    init(id: UUID = UUID(), state: String = "", licenseNumber: String = "") {
        self.id = id
        self.state = state
        self.licenseNumber = licenseNumber
    }
}

// MARK: - Board Certification Model
struct BoardCertification: Identifiable, Codable {
    let id: UUID
    var name: String

    init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss

    // Basic Contact Info
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String
    @State private var address: String

    // Credentials
    @State private var selectedCredentials: Set<String>

    // State Licenses
    @State private var stateLicenses: [StateLicense]

    // Board Certifications
    @State private var boardCertifications: [BoardCertification]

    @State private var showingSavedAlert = false
    @State private var isSaving = false
    @State private var saveError: String? = nil

    let allCredentials = ["MD", "DO", "PA", "APRN", "RN", "CRNA", "DPT", "PTA"]

    let usStates = [
        "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
        "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
        "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
        "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
        "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY",
        "DC"
    ]

    init() {
        _firstName = State(initialValue: UserDefaults.standard.string(forKey: "profileFirstName") ?? UserDefaults.standard.string(forKey: "userFirstName") ?? "")
        _lastName = State(initialValue: UserDefaults.standard.string(forKey: "profileLastName") ?? "")
        _email = State(initialValue: UserDefaults.standard.string(forKey: "profileEmail") ?? UserDefaults.standard.string(forKey: "userEmail") ?? "")
        _phone = State(initialValue: UserDefaults.standard.string(forKey: "profilePhone") ?? "")
        _address = State(initialValue: UserDefaults.standard.string(forKey: "profileAddress") ?? "")

        let savedCredentials = UserDefaults.standard.stringArray(forKey: "profileCredentials") ?? []
        _selectedCredentials = State(initialValue: Set(savedCredentials))

        if let data = UserDefaults.standard.data(forKey: "profileStateLicenses"),
           let decoded = try? JSONDecoder().decode([StateLicense].self, from: data) {
            _stateLicenses = State(initialValue: decoded)
        } else {
            _stateLicenses = State(initialValue: [])
        }

        if let data = UserDefaults.standard.data(forKey: "profileBoardCertifications"),
           let decoded = try? JSONDecoder().decode([BoardCertification].self, from: data) {
            _boardCertifications = State(initialValue: decoded)
        } else {
            _boardCertifications = State(initialValue: [])
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Basic Contact Info
                    SectionCard(title: "Basic Information", icon: "person.fill") {
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                EditFormField(label: "First Name", text: $firstName, placeholder: "John")
                                EditFormField(label: "Last Name", text: $lastName, placeholder: "Doe")
                            }
                            EditFormField(label: "Email", text: $email, placeholder: "john@example.com", keyboardType: .emailAddress)
                            EditFormField(label: "Phone Number", text: $phone, placeholder: "(555) 123-4567", keyboardType: .phonePad)
                            EditFormField(label: "Primary Address", text: $address, placeholder: "123 Main St, City, State ZIP")
                        }
                    }

                    // MARK: Credentials
                    SectionCard(title: "Credentials", icon: "rosette") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select all that apply")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(allCredentials, id: \.self) { credential in
                                    CredentialToggle(
                                        label: credential,
                                        isSelected: selectedCredentials.contains(credential)
                                    ) {
                                        if selectedCredentials.contains(credential) {
                                            selectedCredentials.remove(credential)
                                        } else {
                                            selectedCredentials.insert(credential)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // MARK: State Licenses
                    SectionCard(title: "State Licenses", icon: "doc.badge.checkmark") {
                        VStack(spacing: 12) {
                            if stateLicenses.isEmpty {
                                Text("No state licenses added yet")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach($stateLicenses) { $license in
                                    StateLicenseRow(license: $license, states: usStates) {
                                        stateLicenses.removeAll { $0.id == license.id }
                                    }
                                }
                            }

                            Button(action: {
                                stateLicenses.append(StateLicense())
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add State License")
                                }
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(hex: "667eea"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                        }
                    }

                    // MARK: Board Certifications
                    SectionCard(title: "Board Certifications", icon: "checkmark.seal.fill") {
                        VStack(spacing: 12) {
                            if boardCertifications.isEmpty {
                                Text("No board certifications added yet")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach($boardCertifications) { $cert in
                                    BoardCertificationRow(cert: $cert) {
                                        boardCertifications.removeAll { $0.id == cert.id }
                                    }
                                }
                            }

                            Button(action: {
                                boardCertifications.append(BoardCertification())
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Board Certification")
                                }
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(hex: "667eea"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "667eea"))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await saveProfile() }
                    }) {
                        if isSaving {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundColor(Color(hex: "667eea"))
                    .disabled(isSaving)
                }
            }
            .alert("Profile Saved", isPresented: $showingSavedAlert) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your profile has been updated successfully.")
            }
            .alert("Save Failed", isPresented: Binding(
                get: { saveError != nil },
                set: { if !$0 { saveError = nil } }
            )) {
                Button("OK") {}
            } message: {
                Text(saveError ?? "An unknown error occurred.")
            }
        }
    }

    // MARK: - Save Profile
    private func saveProfile() async {
        isSaving = true
        defer { isSaving = false }

        let token = KeychainService.load(key: "authToken") ?? ""
        let licenseItems = stateLicenses.map { StateLicenseItem(state: $0.state, licenseNumber: $0.licenseNumber) }
        let certItems = boardCertifications.map { BoardCertificationItem(name: $0.name) }
        let credArray = Array(selectedCredentials)

        do {
            let updatedUser = try await APIService.shared.updateWorkerProfile(
                token: token,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phone.isEmpty ? nil : phone,
                address: address.isEmpty ? nil : address,
                credentials: credArray.isEmpty ? nil : credArray,
                stateLicenses: licenseItems.isEmpty ? nil : licenseItems,
                boardCertifications: certItems.isEmpty ? nil : certItems
            )
            persistLocally(user: updatedUser)
            showingSavedAlert = true
        } catch let error as APIError {
            saveError = error.localizedDescription
        } catch {
            saveError = "Network error. Please check your connection."
        }
    }

    private func persistLocally(user: User) {
        let defaults = UserDefaults.standard
        defaults.set(user.firstName, forKey: "profileFirstName")
        defaults.set(user.lastName, forKey: "profileLastName")
        defaults.set(user.email, forKey: "profileEmail")
        if let phone = user.phoneNumber { defaults.set(phone, forKey: "profilePhone") }
        if let addr = user.address { defaults.set(addr, forKey: "profileAddress") }
        if let creds = user.credentials { defaults.set(creds, forKey: "profileCredentials") }
        if let licenses = user.stateLicenses,
           let encoded = try? JSONEncoder().encode(licenses.map { StateLicense(state: $0.state, licenseNumber: $0.licenseNumber) }) {
            defaults.set(encoded, forKey: "profileStateLicenses")
        }
        if let certs = user.boardCertifications,
           let encoded = try? JSONEncoder().encode(certs.map { BoardCertification(name: $0.name) }) {
            defaults.set(encoded, forKey: "profileBoardCertifications")
        }
        defaults.set(user.firstName, forKey: "userFirstName")
        defaults.set(user.email, forKey: "userEmail")
    }
}

// MARK: - Section Card
struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "667eea"))
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "333333"))
            }

            content()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

// MARK: - Edit Form Field
struct EditFormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "666666"))

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .padding(12)
                .background(Color(hex: "f8f9fa"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "e0e0e0"), lineWidth: 1.5)
                )
        }
    }
}

// MARK: - Credential Toggle
struct CredentialToggle: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : Color(hex: "667eea"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color(hex: "667eea") : Color(hex: "667eea").opacity(0.08))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "667eea"), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

// MARK: - State License Row
struct StateLicenseRow: View {
    @Binding var license: StateLicense
    let states: [String]
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                // State Picker
                VStack(alignment: .leading, spacing: 4) {
                    Text("State")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "666666"))

                    Picker("State", selection: $license.state) {
                        Text("Select").tag("")
                        ForEach(states, id: \.self) { state in
                            Text(state).tag(state)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color(hex: "f8f9fa"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "e0e0e0"), lineWidth: 1.5)
                    )
                }
                .frame(maxWidth: 110)

                // License Number
                VStack(alignment: .leading, spacing: 4) {
                    Text("License Number")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "666666"))

                    TextField("e.g. RN123456", text: $license.licenseNumber)
                        .textInputAutocapitalization(.characters)
                        .padding(10)
                        .background(Color(hex: "f8f9fa"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "e0e0e0"), lineWidth: 1.5)
                        )
                }

                // Delete Button
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.red)
                }
                .padding(.top, 20)
            }
        }
        .padding(12)
        .background(Color(hex: "f8f9fa"))
        .cornerRadius(8)
    }
}

// MARK: - Board Certification Row
struct BoardCertificationRow: View {
    @Binding var cert: BoardCertification
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            TextField("e.g. ABIM, ABFM, ANCC", text: $cert.name)
                .padding(10)
                .background(Color(hex: "f8f9fa"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "e0e0e0"), lineWidth: 1.5)
                )

            Button(action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    EditProfileView()
}
