//
//  FacilityProfileView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-03-05.
//

import SwiftUI

struct FacilityProfileView: View {
    let facilityName: String
    let email: String
    let onLogout: () -> Void

    @State private var displayName: String = ""
    @State private var displayEmail: String = ""
    @State private var displayPhone: String = ""
    @State private var displayFacilityType: String = ""
    @State private var displayCity: String = ""
    @State private var displayState: String = ""
    @State private var displayAddress: String = ""
    @State private var displayDescription: String = ""
    @State private var showFacilityDetails = false
    @State private var showingDeleteAccountAlert = false
    @State private var showingDeleteAccountConfirm = false
    @State private var isDeletingAccount = false
    @State private var deleteAccountError: String? = nil
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userType") private var userType = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Facility Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)

                            Image(systemName: "building.2.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }

                        VStack(spacing: 4) {
                            Text(displayName.isEmpty ? facilityName : displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "333333"))

                            if !displayFacilityType.isEmpty {
                                Text(displayFacilityType)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "667eea"))
                            }

                            Text(displayEmail.isEmpty ? email : displayEmail)
                                .font(.footnote)
                                .foregroundColor(.gray)

                            if !displayPhone.isEmpty {
                                Text(displayPhone)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }

                            if !displayCity.isEmpty || !displayState.isEmpty {
                                Label(
                                    [displayCity, displayState].filter { !$0.isEmpty }.joined(separator: ", "),
                                    systemImage: "mappin.and.ellipse"
                                )
                                .font(.footnote)
                                .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top, 20)

                    // Description card (if set)
                    if !displayDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(.headline)
                                .foregroundColor(Color(hex: "333333"))
                            Text(displayDescription)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                        .padding(.horizontal, 24)
                    }

                    // Profile Stats
                    HStack(spacing: 20) {
                        ProfileStat(value: "0", label: "Positions\nPosted")
                        Divider().frame(height: 40)
                        ProfileStat(value: "0", label: "Positions\nFilled")
                        Divider().frame(height: 40)
                        ProfileStat(value: "5.0", label: "Rating")
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    .padding(.horizontal, 24)

                    // Actions
                    VStack(spacing: 12) {
                        ProfileActionButton(
                            icon: "building.2.fill",
                            title: "Facility Details",
                            action: { showFacilityDetails = true }
                        )
                        ProfileActionButton(
                            icon: "bell.fill",
                            title: "Notifications",
                            action: {}
                        )
                        ProfileActionButton(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            action: {}
                        )
                        ProfileActionButton(
                            icon: "gearshape.fill",
                            title: "Settings",
                            action: {}
                        )
                        ProfileActionButton(
                            icon: "doc.plaintext.fill",
                            title: "Terms of Service",
                            action: { showingTerms = true }
                        )
                        ProfileActionButton(
                            icon: "lock.shield.fill",
                            title: "Privacy Policy",
                            action: { showingPrivacy = true }
                        )
                    }
                    .padding(.horizontal, 24)

                    // Sign Out
                    Button(action: onLogout) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .font(.system(size: 20))
                            Text("Sign Out")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    // Delete Account Button
                    Button(action: { showingDeleteAccountAlert = true }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 20))
                            Text("Delete Account")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                    .disabled(isDeletingAccount)

                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { loadFacilityData() }
            .sheet(isPresented: $showFacilityDetails, onDismiss: loadFacilityData) {
                FacilityDetailsView()
            }
            .sheet(isPresented: $showingTerms) {
                LegalView(document: .termsOfService)
            }
            .sheet(isPresented: $showingPrivacy) {
                LegalView(document: .privacyPolicy)
            }
            .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Continue", role: .destructive) {
                    showingDeleteAccountConfirm = true
                }
            } message: {
                Text("This will permanently delete your facility account and all associated data. This action cannot be undone.")
            }
            .alert("Are you sure?", isPresented: $showingDeleteAccountConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Delete My Account", role: .destructive) {
                    Task { await performDeleteAccount() }
                }
            } message: {
                Text("Your facility account, positions, and all data will be permanently removed.")
            }
            .alert("Error", isPresented: Binding(
                get: { deleteAccountError != nil },
                set: { if !$0 { deleteAccountError = nil } }
            )) {
                Button("OK") {}
            } message: {
                Text(deleteAccountError ?? "An error occurred.")
            }
        }
    }

    private func loadFacilityData() {
        displayName = UserDefaults.standard.string(forKey: "facilityName") ?? facilityName
        displayEmail = UserDefaults.standard.string(forKey: "facilityEmail") ?? email
        displayPhone = UserDefaults.standard.string(forKey: "facilityPhone") ?? ""
        displayFacilityType = UserDefaults.standard.string(forKey: "facilityType") ?? ""
        displayCity = UserDefaults.standard.string(forKey: "facilityCity") ?? ""
        displayState = UserDefaults.standard.string(forKey: "facilityState") ?? ""
        displayAddress = UserDefaults.standard.string(forKey: "facilityAddress") ?? ""
        displayDescription = UserDefaults.standard.string(forKey: "facilityDescription") ?? ""
    }

    private func performDeleteAccount() async {
        isDeletingAccount = true
        defer { isDeletingAccount = false }
        let token = KeychainService.load(key: "authToken") ?? ""
        do {
            try await APIService.shared.deleteFacilityAccount(token: token)
            await MainActor.run {
                KeychainService.delete(key: "authToken")
                let keys = [
                    "facilityId", "facilityName", "facilityEmail", "facilityPhone",
                    "facilityType", "facilityCity", "facilityState", "facilityAddress",
                    "facilityDescription", "facilityZipCode", "userType"
                ]
                keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
                userType = ""
                isLoggedIn = false
            }
        } catch {
            await MainActor.run {
                deleteAccountError = "Failed to delete account. Please try again or contact support@yolku.com."
            }
        }
    }
}

#Preview {
    FacilityProfileView(
        facilityName: "General Hospital",
        email: "admin@generalhospital.com",
        onLogout: {}
    )
}
