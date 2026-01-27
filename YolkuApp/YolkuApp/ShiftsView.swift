//
//  ShiftsView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct ShiftsView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    let filters = ["All", "Today", "This Week", "Nearby"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search facilities or locations", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "f5f5f5"))
                
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filters, id: \.self) { filter in
                            FilterChip(
                                title: filter,
                                isSelected: selectedFilter == filter,
                                action: { selectedFilter = filter }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .background(Color(hex: "f5f5f5"))
                
                // Shifts List
                ScrollView {
                    VStack(spacing: 16) {
                        // Empty State
                        VStack(spacing: 20) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(Color(hex: "667eea").opacity(0.3))
                                .padding(.top, 60)
                            
                            Text("No Shifts Available Yet")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "333333"))
                            
                            Text("Check back soon for available shifts\nfrom healthcare facilities near you")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Refresh")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(10)
                            }
                            .padding(.top, 8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        
                        // Example shift cards (commented out for now)
                        /*
                        ShiftCard(
                            facilityName: "General Hospital",
                            location: "San Francisco, CA",
                            position: "Registered Nurse",
                            date: "Jan 28, 2026",
                            time: "7:00 AM - 7:00 PM",
                            rate: "$65/hr"
                        )
                        */
                    }
                    .padding(16)
                }
                .background(Color(hex: "f5f5f5"))
            }
            .navigationTitle("Find Shifts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Filter Chip Component
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : Color(hex: "667eea"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .leading,
                            endPoint: .trailing
                          )
                        : LinearGradient(
                            colors: [Color.white, Color.white],
                            startPoint: .leading,
                            endPoint: .trailing
                          )
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "667eea"), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

// Shift Card Component (for future use)
struct ShiftCard: View {
    let facilityName: String
    let location: String
    let position: String
    let date: String
    let time: String
    let rate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(facilityName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(location)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text(rate)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "667eea"))
            }
            
            Divider()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Position")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(position)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "333333"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date & Time")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(date)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "333333"))
                    Text(time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Button(action: {}) {
                Text("Apply Now")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

#Preview {
    ShiftsView()
}
