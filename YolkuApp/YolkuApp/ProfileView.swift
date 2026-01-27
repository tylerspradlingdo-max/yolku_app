//
//  ProfileView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct ProfileView: View {
    let firstName: String
    let email: String
    let profession: String
    let onLogout: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Profile Picture Placeholder
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
                            
                            Text(firstName.prefix(1).uppercased())
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text(firstName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(profession)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Profile Stats
                    HStack(spacing: 20) {
                        ProfileStat(value: "0", label: "Shifts")
                        
                        Divider()
                            .frame(height: 40)
                        
                        ProfileStat(value: "5.0", label: "Rating")
                        
                        Divider()
                            .frame(height: 40)
                        
                        ProfileStat(value: "$0", label: "Earned")
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    .padding(.horizontal, 24)
                    
                    // Profile Actions
                    VStack(spacing: 12) {
                        ProfileActionButton(
                            icon: "person.fill",
                            title: "Edit Profile",
                            action: {}
                        )
                        
                        ProfileActionButton(
                            icon: "doc.text.fill",
                            title: "Documents & Licenses",
                            action: {}
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
                    }
                    .padding(.horizontal, 24)
                    
                    // Logout Button
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
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Profile Stat Component
struct ProfileStat: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "333333"))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// Profile Action Button Component
struct ProfileActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "667eea"))
                    .frame(width: 40, height: 40)
                    .background(Color(hex: "667eea").opacity(0.1))
                    .cornerRadius(8)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "333333"))
                
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

#Preview {
    ProfileView(
        firstName: "John",
        email: "john@example.com",
        profession: "Registered Nurse (RN)",
        onLogout: {}
    )
}
