//
//  FacilityDashboardView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-03-05.
//

import SwiftUI

struct FacilityDashboardView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userType") private var userType = ""

    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false

    private var facilityName: String {
        UserDefaults.standard.string(forKey: "facilityName") ?? "Healthcare Facility"
    }

    private var facilityEmail: String {
        UserDefaults.standard.string(forKey: "facilityEmail") ?? ""
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            FacilityHomeTabView(facilityName: facilityName, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            // Manage Positions Tab
            FacilityPositionsView()
                .tabItem {
                    Label("Positions", systemImage: "briefcase.fill")
                }
                .tag(1)

            // Messages Tab
            ChatView()
                .tabItem {
                    Label("Messages", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(2)

            // Profile Tab
            FacilityProfileView(
                facilityName: facilityName,
                email: facilityEmail,
                onLogout: handleLogout
            )
            .tabItem {
                Label("Profile", systemImage: "building.2.fill")
            }
            .tag(3)
        }
        .accentColor(Color(hex: "667eea"))
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                performLogout()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }

    private func handleLogout() {
        showingLogoutAlert = true
    }

    private func performLogout() {
        isLoggedIn = false
        userType = ""
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "facilityName")
        UserDefaults.standard.removeObject(forKey: "facilityEmail")
        UserDefaults.standard.removeObject(forKey: "facilityPhone")
        UserDefaults.standard.removeObject(forKey: "facilityType")
        UserDefaults.standard.removeObject(forKey: "facilityCity")
        UserDefaults.standard.removeObject(forKey: "facilityState")
        UserDefaults.standard.removeObject(forKey: "facilityAddress")
        UserDefaults.standard.removeObject(forKey: "facilityDescription")
        UserDefaults.standard.removeObject(forKey: "userType")
    }
}

// MARK: - Facility Home Tab

struct FacilityHomeTabView: View {
    let facilityName: String
    @Binding var selectedTab: Int

    @State private var displayFacilityName: String = ""
    @State private var displayFacilityType: String = ""

    private var displayName: String {
        let name = displayFacilityName.isEmpty ? facilityName : displayFacilityName
        return name.isEmpty ? "Healthcare Facility" : name
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome,")
                            .font(.title2)
                            .foregroundColor(.gray)

                        Text(displayName)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        if !displayFacilityType.isEmpty {
                            Text(displayFacilityType)
                                .font(.headline)
                                .foregroundColor(Color(hex: "667eea"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                    // Quick Stats
                    HStack(spacing: 16) {
                        StatCard(icon: "briefcase.fill", value: "0", label: "Open Positions")
                        StatCard(icon: "person.2.fill", value: "0", label: "Applications")
                    }
                    .padding(.horizontal, 24)

                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 24)

                        VStack(spacing: 12) {
                            Button(action: {
                                selectedTab = 1
                            }) {
                                ActionButton(
                                    icon: "plus.circle.fill",
                                    title: "Create a Position",
                                    subtitle: "Post a new opening for qualified professionals",
                                    color: Color(hex: "667eea")
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                selectedTab = 1
                            }) {
                                ActionButton(
                                    icon: "briefcase.fill",
                                    title: "Manage Positions",
                                    subtitle: "View and manage your posted positions",
                                    color: Color(hex: "764ba2")
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                selectedTab = 2
                            }) {
                                ActionButton(
                                    icon: "envelope.fill",
                                    title: "Messages",
                                    subtitle: "Chat with healthcare professionals",
                                    color: Color(hex: "667eea")
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                selectedTab = 3
                            }) {
                                ActionButton(
                                    icon: "building.2.fill",
                                    title: "Facility Profile",
                                    subtitle: "Update your facility information",
                                    color: Color(hex: "764ba2")
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 24)
                    }

                    // Recent Activity
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Activity")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 24)

                        VStack(spacing: 0) {
                            ActivityItem(
                                icon: "checkmark.circle.fill",
                                title: "Facility Profile Created",
                                subtitle: "Welcome to Yolku!",
                                time: "Just now"
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                        .padding(.horizontal, 24)
                    }

                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "f5f5f5"))
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
            }
            .onAppear {
                displayFacilityName = UserDefaults.standard.string(forKey: "facilityName") ?? facilityName
                displayFacilityType = UserDefaults.standard.string(forKey: "facilityType") ?? ""
            }
        }
    }
}

#Preview {
    FacilityDashboardView()
}
