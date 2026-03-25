//
//  FacilityDetailsView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-03-25.
//

import SwiftUI

struct FacilityDetailsView: View {
    @Environment(\.dismiss) var dismiss

    let facilityTypes = [
        "Hospital",
        "Outpatient Clinic",
        "Surgery Center",
        "Nursing Home",
        "Other"
    ]

    @State private var selectedFacilityType: String
    @State private var address: String
    @State private var city: String
    @State private var state: String
    @State private var phone: String
    @State private var about: String
    @State private var showSavedAlert = false

    init() {
        _selectedFacilityType = State(initialValue: UserDefaults.standard.string(forKey: "facilityType") ?? "")
        _address = State(initialValue: UserDefaults.standard.string(forKey: "facilityAddress") ?? "")
        _city = State(initialValue: UserDefaults.standard.string(forKey: "facilityCity") ?? "")
        _state = State(initialValue: UserDefaults.standard.string(forKey: "facilityState") ?? "")
        _phone = State(initialValue: UserDefaults.standard.string(forKey: "facilityPhone") ?? "")
        _about = State(initialValue: UserDefaults.standard.string(forKey: "facilityDescription") ?? "")
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: – Facility Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Facility Type")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))

                        Picker("Select facility type", selection: $selectedFacilityType) {
                            Text("Select type").tag("")
                            ForEach(facilityTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                        )
                        .cornerRadius(8)
                    }

                    // MARK: – Primary Location
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Primary Location")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))

                        TextField("Street address", text: $address)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                            )
                            .cornerRadius(8)

                        HStack(spacing: 12) {
                            TextField("City", text: $city)
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                                )
                                .cornerRadius(8)

                            TextField("State", text: $state)
                                .padding()
                                .frame(width: 90)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                    }

                    // MARK: – Primary Contact Number
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Primary Contact Number")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))

                        TextField("e.g. (555) 123-4567", text: $phone)
                            .keyboardType(.phonePad)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                            )
                            .cornerRadius(8)
                    }

                    // MARK: – About
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))

                        ZStack(alignment: .topLeading) {
                            if about.isEmpty {
                                Text("Write a short description of your facility…")
                                    .foregroundColor(Color(hex: "aaaaaa"))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                            }
                            TextEditor(text: $about)
                                .frame(minHeight: 110)
                                .padding(8)
                                .opacity(about.isEmpty ? 0.25 : 1)
                        }
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                        )
                        .cornerRadius(8)
                    }

                    // MARK: – Save button
                    Button(action: saveDetails) {
                        Text("Save Details")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
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
                    .padding(.top, 8)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Facility Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(hex: "667eea"))
                }
            }
            .alert("Details Saved", isPresented: $showSavedAlert) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your facility details have been updated.")
            }
        }
    }

    private func saveDetails() {
        UserDefaults.standard.set(selectedFacilityType, forKey: "facilityType")
        UserDefaults.standard.set(address, forKey: "facilityAddress")
        UserDefaults.standard.set(city, forKey: "facilityCity")
        UserDefaults.standard.set(state, forKey: "facilityState")
        UserDefaults.standard.set(phone, forKey: "facilityPhone")
        UserDefaults.standard.set(about, forKey: "facilityDescription")
        showSavedAlert = true
    }
}

#Preview {
    FacilityDetailsView()
}
