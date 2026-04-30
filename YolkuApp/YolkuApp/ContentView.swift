//
//  ContentView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userType") private var userType = ""
    @State private var showMenu = false
    @State private var showSignIn = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                if userType == "facility" {
                    FacilityDashboardView()
                        .task { await syncFacilityProfile() }
                } else {
                    DashboardView()
                        .task { await syncWorkerProfile() }
                }
            } else {
                NavigationView {
                    ScrollView {
                        VStack(spacing: 0) {
                            HeroView()
                            FeaturesView()
                            AppPreviewView()
                            DownloadView()
                            FooterView()
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            // LOGO: Using image logo from Assets.xcassets
                            Image("AppLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .accessibilityLabel("Yolku logo")
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Sign In") {
                                showSignIn = true
                            }
                            .buttonStyle(OutlineButtonStyle())
                        }
                    }
                    .sheet(isPresented: $showSignIn) {
                        SignInView()
                    }
                }
            }
        }
        // Automatically log out when the server returns 401 (expired/invalid token)
        .onReceive(NotificationCenter.default.publisher(for: .didReceiveUnauthorizedResponse)) { _ in
            performLogout()
        }
    }

    // MARK: - Logout

    private func performLogout() {
        KeychainService.delete(key: "authToken")
        clearAllProfileDefaults()
        isLoggedIn = false
        userType = ""
    }

    private func clearAllProfileDefaults() {
        let keys = [
            "userId", "userEmail", "userFirstName", "userProfession", "userType",
            "profileFirstName", "profileLastName", "profileEmail", "profilePhone",
            "profileAddress", "profileCredentials", "profileStateLicenses",
            "profileBoardCertifications", "profileImage",
            "facilityId", "facilityName", "facilityEmail", "facilityPhone",
            "facilityType", "facilityCity", "facilityState", "facilityAddress",
            "facilityZipCode", "facilityDescription"
        ]
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }

    // MARK: - Profile Sync

    private func syncWorkerProfile() async {
        guard let token = KeychainService.load(key: "authToken"), !token.isEmpty else { return }
        guard let user = try? await APIService.shared.getProfile(token: token) else { return }
        let defaults = UserDefaults.standard
        defaults.set(user.id, forKey: "userId")
        defaults.set(user.firstName, forKey: "userFirstName")
        defaults.set(user.email, forKey: "userEmail")
        defaults.set(user.profession, forKey: "userProfession")
        defaults.set(user.firstName, forKey: "profileFirstName")
        defaults.set(user.lastName, forKey: "profileLastName")
        defaults.set(user.email, forKey: "profileEmail")
        if let phone = user.phoneNumber { defaults.set(phone, forKey: "profilePhone") }
        if let address = user.address { defaults.set(address, forKey: "profileAddress") }
        if let creds = user.credentials { defaults.set(creds, forKey: "profileCredentials") }
        if let licenses = user.stateLicenses,
           let encoded = try? JSONEncoder().encode(licenses.map { StateLicense(state: $0.state, licenseNumber: $0.licenseNumber) }) {
            defaults.set(encoded, forKey: "profileStateLicenses")
        }
        if let certs = user.boardCertifications,
           let encoded = try? JSONEncoder().encode(certs.map { BoardCertification(name: $0.name) }) {
            defaults.set(encoded, forKey: "profileBoardCertifications")
        }
    }

    private func syncFacilityProfile() async {
        guard let token = KeychainService.load(key: "authToken"), !token.isEmpty else { return }
        guard let facility = try? await APIService.shared.fetchFacilityProfile(token: token) else { return }
        let defaults = UserDefaults.standard
        defaults.set(facility.id, forKey: "facilityId")
        defaults.set(facility.name, forKey: "facilityName")
        defaults.set(facility.email, forKey: "facilityEmail")
        defaults.set(facility.facilityType, forKey: "facilityType")
        defaults.set(facility.city, forKey: "facilityCity")
        defaults.set(facility.state, forKey: "facilityState")
        defaults.set(facility.address, forKey: "facilityAddress")
        defaults.set(facility.zipCode, forKey: "facilityZipCode")
        if let phone = facility.phoneNumber { defaults.set(phone, forKey: "facilityPhone") }
        if let desc = facility.description { defaults.set(desc, forKey: "facilityDescription") }
    }
}

#Preview {
    ContentView()
}
