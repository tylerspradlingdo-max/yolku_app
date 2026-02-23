//
//  HousingView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-02-23.
//

import SwiftUI

// MARK: - Housing Type
enum HousingType: String, CaseIterable {
    case studio = "Studio"
    case oneBedroom = "1 Bedroom"
    case twoBedroom = "2 Bedroom"
    case shared = "Shared Room"
    case house = "House"
}

// MARK: - Housing Listing Model
struct HousingListing: Identifiable {
    let id: UUID
    let title: String
    let address: String
    let city: String
    let state: String
    let pricePerWeek: Int
    let type: HousingType
    let isFurnished: Bool
    let isAvailable: Bool
    let distanceToFacility: String
    let contactName: String
    let contactPhone: String
    let amenities: [String]

    init(
        id: UUID = UUID(),
        title: String,
        address: String,
        city: String,
        state: String,
        pricePerWeek: Int,
        type: HousingType,
        isFurnished: Bool,
        isAvailable: Bool,
        distanceToFacility: String,
        contactName: String,
        contactPhone: String,
        amenities: [String]
    ) {
        self.id = id
        self.title = title
        self.address = address
        self.city = city
        self.state = state
        self.pricePerWeek = pricePerWeek
        self.type = type
        self.isFurnished = isFurnished
        self.isAvailable = isAvailable
        self.distanceToFacility = distanceToFacility
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.amenities = amenities
    }

    var formattedPrice: String {
        "$\(pricePerWeek)/wk"
    }

    var location: String {
        "\(city), \(state)"
    }
}

// MARK: - Sample Data
private let sampleListings: [HousingListing] = [
    HousingListing(
        title: "Modern Studio near Downtown Hospital",
        address: "142 Oak Street",
        city: "Austin",
        state: "TX",
        pricePerWeek: 350,
        type: .studio,
        isFurnished: true,
        isAvailable: true,
        distanceToFacility: "0.8 mi",
        contactName: "Riverside Properties",
        contactPhone: "512-555-0101",
        amenities: ["WiFi", "Washer/Dryer", "Parking", "AC"]
    ),
    HousingListing(
        title: "Furnished 1BR Apartment – Travel Nurse Friendly",
        address: "88 Maple Avenue",
        city: "Austin",
        state: "TX",
        pricePerWeek: 475,
        type: .oneBedroom,
        isFurnished: true,
        isAvailable: true,
        distanceToFacility: "1.2 mi",
        contactName: "Home Away Rentals",
        contactPhone: "512-555-0202",
        amenities: ["WiFi", "Kitchen", "Gym", "Pool", "Parking"]
    ),
    HousingListing(
        title: "Shared Room in Healthcare Worker House",
        address: "310 Birch Lane",
        city: "Austin",
        state: "TX",
        pricePerWeek: 200,
        type: .shared,
        isFurnished: true,
        isAvailable: true,
        distanceToFacility: "2.1 mi",
        contactName: "Community Housing Co.",
        contactPhone: "512-555-0303",
        amenities: ["WiFi", "Shared Kitchen", "Laundry", "Parking"]
    ),
    HousingListing(
        title: "Spacious 2BR Close to Medical Center",
        address: "55 Cedar Drive",
        city: "Austin",
        state: "TX",
        pricePerWeek: 620,
        type: .twoBedroom,
        isFurnished: false,
        isAvailable: true,
        distanceToFacility: "0.5 mi",
        contactName: "MedCity Realty",
        contactPhone: "512-555-0404",
        amenities: ["Washer/Dryer", "Dishwasher", "AC", "Balcony"]
    ),
    HousingListing(
        title: "Cozy House – Short-Term Lease Available",
        address: "19 Willow Court",
        city: "Austin",
        state: "TX",
        pricePerWeek: 750,
        type: .house,
        isFurnished: true,
        isAvailable: false,
        distanceToFacility: "3.0 mi",
        contactName: "Sunbelt Rentals",
        contactPhone: "512-555-0505",
        amenities: ["WiFi", "Full Kitchen", "Backyard", "Garage", "Washer/Dryer"]
    )
]

// MARK: - Housing View
struct HousingView: View {
    @Environment(\.dismiss) var dismiss

    @State private var searchText = ""
    @State private var selectedType: HousingType? = nil
    @State private var showTypeFilter = false
    @State private var showFurnishedOnly = false
    @State private var selectedListing: HousingListing? = nil

    private let listings = sampleListings

    var filteredListings: [HousingListing] {
        listings.filter { listing in
            let matchesSearch = searchText.isEmpty ||
                listing.title.localizedCaseInsensitiveContains(searchText) ||
                listing.city.localizedCaseInsensitiveContains(searchText) ||
                listing.state.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedType == nil || listing.type == selectedType
            let matchesFurnished = !showFurnishedOnly || listing.isFurnished
            return matchesSearch && matchesType && matchesFurnished
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by city or listing name", text: $searchText)
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

                // Filter Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // Housing Type Filter
                        Button(action: { showTypeFilter = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "bed.double")
                                Text(selectedType?.rawValue ?? "All Types")
                                if selectedType != nil {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                        .onTapGesture { selectedType = nil }
                                }
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedType != nil ? .white : Color(hex: "667eea"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedType != nil
                                    ? LinearGradient(
                                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                    : LinearGradient(
                                        colors: [Color.white, Color.white],
                                        startPoint: .leading,
                                        endPoint: .trailing)
                            )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "667eea"), lineWidth: selectedType != nil ? 0 : 1)
                            )
                        }

                        // Furnished Toggle
                        Button(action: { showFurnishedOnly.toggle() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "sofa")
                                Text("Furnished")
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(showFurnishedOnly ? .white : Color(hex: "667eea"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                showFurnishedOnly
                                    ? LinearGradient(
                                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                    : LinearGradient(
                                        colors: [Color.white, Color.white],
                                        startPoint: .leading,
                                        endPoint: .trailing)
                            )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "667eea"), lineWidth: showFurnishedOnly ? 0 : 1)
                            )
                        }

                        // Clear All
                        if selectedType != nil || showFurnishedOnly {
                            Button(action: {
                                selectedType = nil
                                showFurnishedOnly = false
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

                // Listings
                ScrollView {
                    VStack(spacing: 16) {
                        if filteredListings.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "house.slash")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(hex: "667eea").opacity(0.3))
                                    .padding(.top, 60)

                                Text("No Listings Found")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "333333"))

                                Text("Try adjusting your search or filters\nto find available housing.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ForEach(filteredListings) { listing in
                                Button(action: { selectedListing = listing }) {
                                    HousingCard(listing: listing)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(16)
                }
                .background(Color(hex: "f5f5f5"))
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Find Housing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showTypeFilter) {
                HousingTypeFilterSheet(
                    selectedType: $selectedType,
                    onApply: { showTypeFilter = false }
                )
            }
            .sheet(item: $selectedListing) { listing in
                HousingDetailView(listing: listing)
            }
        }
    }
}

// MARK: - Housing Card
struct HousingCard: View {
    let listing: HousingListing

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(listing.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(listing.location)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(listing.formattedPrice)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "667eea"))

                    if listing.isAvailable {
                        Text("Available")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                    } else {
                        Text("Unavailable")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }

            Divider()

            HStack(spacing: 20) {
                HousingDetailChip(icon: "bed.double", text: listing.type.rawValue)
                HousingDetailChip(icon: "figure.walk", text: listing.distanceToFacility)
                if listing.isFurnished {
                    HousingDetailChip(icon: "sofa", text: "Furnished")
                }
            }

            if !listing.amenities.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(listing.amenities.prefix(4), id: \.self) { amenity in
                            Text(amenity)
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "667eea"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(hex: "667eea").opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

// MARK: - Housing Detail Chip
struct HousingDetailChip: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "667eea"))
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "555555"))
        }
    }
}

// MARK: - Housing Type Filter Sheet
struct HousingTypeFilterSheet: View {
    @Binding var selectedType: HousingType?
    let onApply: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    selectedType = nil
                    onApply()
                }) {
                    HStack {
                        Text("All Types")
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedType == nil {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "667eea"))
                        }
                    }
                }

                ForEach(HousingType.allCases, id: \.self) { type in
                    Button(action: {
                        selectedType = type
                        onApply()
                    }) {
                        HStack {
                            Text(type.rawValue)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedType == type {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(hex: "667eea"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Housing Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Housing Detail View
struct HousingDetailView: View {
    let listing: HousingListing
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(listing.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "333333"))

                                HStack(spacing: 4) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.gray)
                                    Text("\(listing.address), \(listing.city), \(listing.state)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text(listing.formattedPrice)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "667eea"))
                                Text("per week")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }

                        Divider()

                        HStack(spacing: 24) {
                            HousingInfoItem(
                                icon: "bed.double.fill",
                                label: "Type",
                                value: listing.type.rawValue
                            )
                            HousingInfoItem(
                                icon: "figure.walk",
                                label: "Distance",
                                value: listing.distanceToFacility
                            )
                            HousingInfoItem(
                                icon: "sofa.fill",
                                label: "Furnished",
                                value: listing.isFurnished ? "Yes" : "No"
                            )
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    // Amenities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amenities")
                            .font(.headline)
                            .foregroundColor(Color(hex: "333333"))
                            .padding(.horizontal, 16)

                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 12
                        ) {
                            ForEach(listing.amenities, id: \.self) { amenity in
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "667eea"))
                                        .font(.system(size: 16))
                                    Text(amenity)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "333333"))
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Contact Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact")
                            .font(.headline)
                            .foregroundColor(Color(hex: "333333"))

                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 50, height: 50)
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(listing.contactName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(hex: "333333"))
                                Text(listing.contactPhone)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }

                        if let url = URL(string: "tel:\(listing.contactPhone.filter { $0.isNumber })") {
                            Link(destination: url) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("Call \(listing.contactName)")
                                        .fontWeight(.semibold)
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
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
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    if !listing.isAvailable {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 20))
                            Text("This listing is currently unavailable. Contact the owner to check future availability.")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "555555"))
                        }
                        .padding(16)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 32)
                }
                .padding(.top, 16)
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Housing Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Housing Info Item
struct HousingInfoItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "667eea"))
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "333333"))
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    HousingView()
}
