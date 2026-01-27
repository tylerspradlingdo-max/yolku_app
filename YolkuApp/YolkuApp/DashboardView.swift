//
//  DashboardView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct DashboardView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userFirstName") private var userFirstName = ""
    @AppStorage("userEmail") private var userEmail = ""
    @AppStorage("userProfession") private var userProfession = ""
    
    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab - Dashboard
            HomeTabView(firstName: userFirstName, profession: userProfession)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            // Positions Tab
            ShiftsView()
                .tabItem {
                    Label("Find Positions", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            // My Positions Tab
            MyShiftsView()
                .tabItem {
                    Label("My Positions", systemImage: "calendar")
                }
                .tag(2)
            
            // Profile Tab
            ProfileView(
                firstName: userFirstName,
                email: userEmail,
                profession: userProfession,
                onLogout: handleLogout
            )
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(3)
        }
        .accentColor(Color(hex: "667eea"))
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
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
        // Clear authentication state
        isLoggedIn = false
        userFirstName = ""
        userEmail = ""
        userProfession = ""
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
}

// Home Tab - Main Dashboard
struct HomeTabView: View {
    let firstName: String
    let profession: String
    
    @State private var showingAvailability = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back,")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text(firstName.isEmpty ? "Healthcare Professional" : firstName)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        if !profession.isEmpty {
                            Text(profession)
                                .font(.headline)
                                .foregroundColor(Color(hex: "667eea"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Quick Stats
                    HStack(spacing: 16) {
                        StatCard(icon: "briefcase.fill", value: "0", label: "Positions Completed")
                        StatCard(icon: "star.fill", value: "5.0", label: "Rating")
                    }
                    .padding(.horizontal, 24)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            ActionButton(
                                icon: "magnifyingglass",
                                title: "Find Available Positions",
                                subtitle: "Browse healthcare facilities near you",
                                color: Color(hex: "667eea")
                            )
                            
                            ActionButton(
                                icon: "calendar",
                                title: "View My Schedule",
                                subtitle: "See your upcoming positions",
                                color: Color(hex: "764ba2")
                            )
                            
                            Button(action: {
                                showingAvailability = true
                            }) {
                                ActionButton(
                                    icon: "calendar.badge.plus",
                                    title: "My Availability",
                                    subtitle: "Set dates you're available to work",
                                    color: Color(hex: "667eea")
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            ActionButton(
                                icon: "envelope.fill",
                                title: "Messages",
                                subtitle: "Chat with facilities",
                                color: Color(hex: "764ba2")
                            )
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
                                title: "Profile Created",
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
            .sheet(isPresented: $showingAvailability) {
                AvailabilityView()
            }
        }
    }
}

// Stat Card Component
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(Color(hex: "667eea"))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

// Action Button Component
struct ActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        }
    }
}

// Activity Item Component
struct ActivityItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let time: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "667eea"))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "333333"))
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(time)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(16)
    }
}

#Preview {
    DashboardView()
}
