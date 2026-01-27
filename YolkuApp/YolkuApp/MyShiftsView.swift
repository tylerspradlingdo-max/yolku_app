//
//  MyShiftsView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct MyShiftsView: View {
    @State private var selectedSegment = 0
    let segments = ["Upcoming", "Completed"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented Control
                Picker("Shifts", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(segments[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(16)
                .background(Color(hex: "f5f5f5"))
                
                // Content
                ScrollView {
                    if selectedSegment == 0 {
                        // Upcoming Shifts
                        EmptyStateView(
                            icon: "calendar.badge.clock",
                            title: "No Upcoming Shifts",
                            subtitle: "Apply for shifts in the Find Shifts tab",
                            buttonTitle: "Find Shifts",
                            buttonAction: {}
                        )
                    } else {
                        // Completed Shifts
                        EmptyStateView(
                            icon: "checkmark.circle",
                            title: "No Completed Shifts Yet",
                            subtitle: "Your completed shifts will appear here",
                            buttonTitle: nil,
                            buttonAction: nil
                        )
                    }
                }
                .background(Color(hex: "f5f5f5"))
            }
            .navigationTitle("My Shifts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Empty State Component
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "667eea").opacity(0.3))
                .padding(.top, 80)
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "333333"))
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    Text(buttonTitle)
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
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// My Shift Card Component (for future use)
struct MyShiftCard: View {
    let facilityName: String
    let location: String
    let position: String
    let date: String
    let time: String
    let status: String
    let statusColor: Color
    
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
                
                Text(status)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(12)
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
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("View Details")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "667eea"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "667eea"), lineWidth: 1.5)
                        )
                }
                
                Button(action: {}) {
                    Text("Get Directions")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
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
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

#Preview {
    MyShiftsView()
}
