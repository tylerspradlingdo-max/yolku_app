//
//  AvailabilityView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

// MARK: - Availability Model
struct AvailabilityDate: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var isFullDay: Bool
    var startTime: Date?
    var endTime: Date?
    var notes: String
    var createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var timeRange: String {
        if isFullDay {
            return "All Day"
        } else if let start = startTime, let end = endTime {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        }
        return "All Day"
    }
}

// MARK: - Availability View
struct AvailabilityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var availabilityDates: [AvailabilityDate] = []
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "f5f5f5")
                    .ignoresSafeArea()
                
                if availabilityDates.isEmpty {
                    emptyStateView
                } else {
                    availabilityListView
                }
            }
            .navigationTitle("My Availability")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "667eea"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            .onAppear {
                loadAvailability()
            }
            .sheet(isPresented: $showingAddSheet) {
                AddAvailabilityView(onSave: { newDate in
                    availabilityDates.append(newDate)
                    availabilityDates.sort { $0.date < $1.date }
                    saveAvailability()
                })
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea").opacity(0.2), Color(hex: "764ba2").opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text("No Availability Set")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Add dates when you're available to work")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingAddSheet = true
            }) {
                Text("Add Availability")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Availability List
    private var availabilityListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(availabilityDates) { availability in
                    AvailabilityCard(availability: availability) {
                        deleteAvailability(availability)
                    }
                }
            }
            .padding(24)
        }
    }
    
    // MARK: - Data Persistence
    private func loadAvailability() {
        if let data = UserDefaults.standard.data(forKey: "userAvailability"),
           let decoded = try? JSONDecoder().decode([AvailabilityDate].self, from: data) {
            availabilityDates = decoded.sorted { $0.date < $1.date }
        }
    }
    
    private func saveAvailability() {
        if let encoded = try? JSONEncoder().encode(availabilityDates) {
            UserDefaults.standard.set(encoded, forKey: "userAvailability")
        }
    }
    
    private func deleteAvailability(_ availability: AvailabilityDate) {
        availabilityDates.removeAll { $0.id == availability.id }
        saveAvailability()
    }
}

// MARK: - Availability Card
struct AvailabilityCard: View {
    let availability: AvailabilityDate
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Calendar Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea").opacity(0.2), Color(hex: "764ba2").opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Date Info
            VStack(alignment: .leading, spacing: 4) {
                Text(availability.formattedDate)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(availability.timeRange)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "667eea"))
                
                if !availability.notes.isEmpty {
                    Text(availability.notes)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Delete Button
            Button(action: {
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        .alert("Delete Availability", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to remove this availability date?")
        }
    }
}

// MARK: - Add Availability View
struct AddAvailabilityView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (AvailabilityDate) -> Void
    
    @State private var selectedDate = Date()
    @State private var isFullDay = true
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                
                Section(header: Text("Time")) {
                    Toggle("Available All Day", isOn: $isFullDay)
                    
                    if !isFullDay {
                        DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Notes (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Availability")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAvailability()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "667eea"))
                }
            }
        }
    }
    
    private func saveAvailability() {
        let newAvailability = AvailabilityDate(
            date: selectedDate,
            isFullDay: isFullDay,
            startTime: isFullDay ? nil : startTime,
            endTime: isFullDay ? nil : endTime,
            notes: notes,
            createdAt: Date()
        )
        
        onSave(newAvailability)
        dismiss()
    }
}
