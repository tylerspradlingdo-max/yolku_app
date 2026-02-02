//
//  ShiftsView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct ShiftsView: View {
    @State private var searchText = ""
    @State private var selectedState: String? = nil
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var showStateFilter = false
    @State private var showDateRangeFilter = false
    
    @State private var positions: [Position] = []
    @State private var availableStates: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
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
                        // State Filter
                        Button(action: { showStateFilter = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "map")
                                Text(selectedState ?? "All States")
                                if selectedState != nil {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                        .onTapGesture {
                                            selectedState = nil
                                            Task { await loadPositions() }
                                        }
                                }
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedState != nil ? .white : Color(hex: "667eea"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedState != nil
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
                                    .stroke(Color(hex: "667eea"), lineWidth: selectedState != nil ? 0 : 1)
                            )
                        }
                        
                        // Date Range Filter
                        Button(action: { showDateRangeFilter = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                Text(dateRangeText)
                                if startDate != nil || endDate != nil {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                        .onTapGesture {
                                            startDate = nil
                                            endDate = nil
                                            Task { await loadPositions() }
                                        }
                                }
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor((startDate != nil || endDate != nil) ? .white : Color(hex: "667eea"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                (startDate != nil || endDate != nil)
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
                                    .stroke(Color(hex: "667eea"), lineWidth: (startDate != nil || endDate != nil) ? 0 : 1)
                            )
                        }
                        
                        // Clear All Filters
                        if selectedState != nil || startDate != nil || endDate != nil {
                            Button(action: {
                                selectedState = nil
                                startDate = nil
                                endDate = nil
                                Task { await loadPositions() }
                            }) {
                                Text("Clear All")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .background(Color(hex: "f5f5f5"))
                
                // Positions List
                ScrollView {
                    VStack(spacing: 16) {
                        if isLoading {
                            ProgressView()
                                .padding(.top, 60)
                        } else if let error = errorMessage {
                            VStack(spacing: 20) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red.opacity(0.3))
                                    .padding(.top, 60)
                                
                                Text("Error Loading Positions")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text(error)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Button(action: { Task { await loadPositions() } }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Retry")
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
                            }
                        } else if filteredPositions.isEmpty {
                            // Empty State
                            VStack(spacing: 20) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(hex: "667eea").opacity(0.3))
                                    .padding(.top, 60)
                                
                                Text("No Positions Available")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "333333"))
                                
                                Text("Check back soon for available positions\nfrom healthcare facilities near you")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Button(action: { Task { await loadPositions() } }) {
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
                        } else {
                            // Position Cards
                            ForEach(filteredPositions) { position in
                                ShiftCard(position: position)
                            }
                        }
                    }
                    .padding(16)
                }
                .background(Color(hex: "f5f5f5"))
            }
            .navigationTitle("Find Positions")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showStateFilter) {
                StateFilterSheet(
                    availableStates: availableStates,
                    selectedState: $selectedState,
                    onApply: {
                        showStateFilter = false
                        Task { await loadPositions() }
                    }
                )
            }
            .sheet(isPresented: $showDateRangeFilter) {
                DateRangeFilterSheet(
                    startDate: $startDate,
                    endDate: $endDate,
                    onApply: {
                        showDateRangeFilter = false
                        Task { await loadPositions() }
                    }
                )
            }
            .task {
                await loadPositions()
                await loadStates()
            }
        }
    }
    
    private var dateRangeText: String {
        if let start = startDate, let end = endDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        } else if let start = startDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return "From \(formatter.string(from: start))"
        } else if let end = endDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return "Until \(formatter.string(from: end))"
        }
        return "Date Range"
    }
    
    private var filteredPositions: [Position] {
        if searchText.isEmpty {
            return positions
        }
        return positions.filter { position in
            position.facility.name.localizedCaseInsensitiveContains(searchText) ||
            position.facility.city.localizedCaseInsensitiveContains(searchText) ||
            position.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func loadPositions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let startDateStr = startDate.map { dateFormatter.string(from: $0) }
            let endDateStr = endDate.map { dateFormatter.string(from: $0) }
            
            positions = try await APIService.shared.getPositions(
                state: selectedState,
                startDate: startDateStr,
                endDate: endDateStr
            )
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func loadStates() async {
        do {
            availableStates = try await APIService.shared.getAvailableStates()
        } catch {
            // Fail silently for states, user can still browse without state filter
            print("Failed to load states: \(error)")
        }
    }
}

// State Filter Sheet
struct StateFilterSheet: View {
    let availableStates: [String]
    @Binding var selectedState: String?
    let onApply: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    selectedState = nil
                    onApply()
                }) {
                    HStack {
                        Text("All States")
                        Spacer()
                        if selectedState == nil {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "667eea"))
                        }
                    }
                }
                
                ForEach(availableStates, id: \.self) { state in
                    Button(action: {
                        selectedState = state
                        onApply()
                    }) {
                        HStack {
                            Text(state)
                            Spacer()
                            if selectedState == state {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(hex: "667eea"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter by State")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Date Range Filter Sheet
struct DateRangeFilterSheet: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    let onApply: () -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var tempStartDate: Date = Date()
    @State private var tempEndDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
    @State private var useStartDate = false
    @State private var useEndDate = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Start Date")) {
                    Toggle("Filter by start date", isOn: $useStartDate)
                    if useStartDate {
                        DatePicker("From", selection: $tempStartDate, displayedComponents: .date)
                    }
                }
                
                Section(header: Text("End Date")) {
                    Toggle("Filter by end date", isOn: $useEndDate)
                    if useEndDate {
                        DatePicker("Until", selection: $tempEndDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Date Range")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        startDate = useStartDate ? tempStartDate : nil
                        endDate = useEndDate ? tempEndDate : nil
                        onApply()
                    }
                }
            }
            .onAppear {
                if let start = startDate {
                    tempStartDate = start
                    useStartDate = true
                }
                if let end = endDate {
                    tempEndDate = end
                    useEndDate = true
                }
            }
        }
    }
}

// Shift Card Component
struct ShiftCard: View {
    let position: Position
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(position.facility.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(position.facility.location)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text(position.formattedRate)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "667eea"))
            }
            
            Divider()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Position")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(position.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "333333"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date & Time")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(position.formattedDate)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "333333"))
                    Text(position.formattedTime)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            if position.openings > 1 {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "667eea"))
                    Text("\(position.openings) openings available")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
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
