//
//  CreatePositionView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-03-05.
//

import SwiftUI

struct CreatePositionView: View {
    @Environment(\.dismiss) var dismiss
    let existingPosition: FacilityPosition?
    let onCreated: (FacilityPosition) -> Void

    init(existingPosition: FacilityPosition? = nil, onCreated: @escaping (FacilityPosition) -> Void) {
        self.existingPosition = existingPosition
        self.onCreated = onCreated
    }

    @State private var title = ""
    @State private var profession = ""
    @State private var positionDescription = ""
    @State private var requirements = ""
    @State private var startDate = Date()
    @State private var hasEndDate = false
    @State private var endDate = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
    @State private var salary = ""
    @State private var compensationType = "annual_salary"
    @State private var location = ""
    @State private var openings = 1
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private var isEditing: Bool { existingPosition != nil }

    let professions = ["RN", "LPN", "CNA", "Doctor", "PA", "NP", "Therapist", "Pharmacist", "Other"]

    let compensationTypes: [(id: String, label: String, placeholder: String, keyboardType: UIKeyboardType)] = [
        (id: "annual_salary", label: "Annual Salary ($) *", placeholder: "e.g. 75000",  keyboardType: .numberPad),
        (id: "daily_rate",    label: "Daily Rate ($) *",   placeholder: "e.g. 350",    keyboardType: .decimalPad),
        (id: "hourly_rate",   label: "Hourly Rate ($) *",  placeholder: "e.g. 45",     keyboardType: .decimalPad)
    ]

    private var selectedCompensation: (id: String, label: String, placeholder: String, keyboardType: UIKeyboardType) {
        compensationTypes.first { $0.id == compensationType } ?? compensationTypes[0]
    }

    private let isoFormatter: ISO8601DateFormatter = {
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withInternetDateTime]
        return fmt
    }()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    FormField(label: "Position Title *", text: $title, placeholder: "e.g. RN – Day Shift ICU")

                    // Profession Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Profession *")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))

                        Picker("Select profession", selection: $profession) {
                            Text("Select profession").tag("")
                            ForEach(professions, id: \.self) { p in
                                Text(p).tag(p)
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
                    }

                    // Start Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start Date *")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))
                        DatePicker("Start Date", selection: $startDate, in: isEditing ? Date.distantPast...Date.distantFuture : Date()..., displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                            )
                    }

                    // End Date (optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle(isOn: $hasEndDate) {
                            Text("Set End Date")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "333333"))
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color(hex: "667eea")))
                        if hasEndDate {
                            DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                                )
                        }
                    }

                    // Compensation Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Compensation Type *")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))

                        Picker("Select compensation type", selection: $compensationType) {
                            ForEach(compensationTypes, id: \.id) { ct in
                                Text(ct.label.replacingOccurrences(of: " *", with: "")).tag(ct.id)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Salary / Rate
                    FormField(label: selectedCompensation.label, text: $salary, placeholder: selectedCompensation.placeholder, keyboardType: selectedCompensation.keyboardType)

                    // Number of Openings
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Number of Openings *")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))
                        Stepper(value: $openings, in: 1...99) {
                            Text("\(openings) \(openings == 1 ? "opening" : "openings")")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "333333"))
                        }
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                        )
                    }

                    // Location (optional)
                    FormField(label: "Location (Optional)", text: $location, placeholder: "e.g. Floor 3 – ICU")

                    // Description (optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description (Optional)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))
                        TextEditor(text: $positionDescription)
                            .frame(height: 90)
                            .padding(8)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                            )
                    }

                    // Requirements (optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Requirements (Optional)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "333333"))
                        TextEditor(text: $requirements)
                            .frame(height: 90)
                            .padding(8)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                            )
                    }

                    // Submit
                    Button(action: handleCreate) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        } else {
                            Text(isEditing ? "Save Changes" : "Create Position")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .disabled(isLoading)
                    .padding(.top, 8)

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Color(hex: "f8f9fa"))
            .navigationTitle(isEditing ? "Edit Position" : "New Position")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(hex: "667eea"))
                }
            }
            .alert(isEditing ? "Edit Position" : "Create Position", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .onAppear { prefillIfEditing() }
        }
    }

    private func prefillIfEditing() {
        guard let p = existingPosition else { return }
        title = p.title
        profession = p.profession
        positionDescription = p.description ?? ""
        requirements = p.requirements ?? ""
        compensationType = p.compensationType
        salary = p.compensationType == "annual_salary"
            ? String(format: "%.0f", p.salary)
            : String(format: "%.2f", p.salary)
        location = p.location ?? ""
        openings = p.openings
        if let parsed = isoFormatter.date(from: p.startDate) {
            startDate = parsed
        }
        if let endStr = p.endDate, let parsed = isoFormatter.date(from: endStr) {
            hasEndDate = true
            endDate = parsed
        }
    }

    private func handleCreate() {
        guard let errorMessage = validateInput() else {
            submitPosition()
            return
        }
        alertMessage = errorMessage
        showAlert = true
    }

    private func validateInput() -> String? {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Please enter a position title."
        }
        if profession.isEmpty {
            return "Please select a profession."
        }
        if salary.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Please enter a \(selectedCompensation.label.replacingOccurrences(of: " ($) *", with: "").lowercased())."
        }
        if Double(salary) == nil {
            return "Please enter a valid salary amount."
        }
        return nil
    }

    private func submitPosition() {
        isLoading = true
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let startDateStr = isoFormatter.string(from: startDate)
        let endDateStr = hasEndDate ? isoFormatter.string(from: endDate) : nil
        let salaryValue = Double(salary) ?? 0

        Task {
            do {
                let position: FacilityPosition
                if let existing = existingPosition {
                    position = try await APIService.shared.updateFacilityPosition(
                        token: token,
                        positionId: existing.id,
                        title: title.trimmingCharacters(in: .whitespaces),
                        profession: profession,
                        description: positionDescription.isEmpty ? nil : positionDescription,
                        requirements: requirements.isEmpty ? nil : requirements,
                        startDate: startDateStr,
                        endDate: endDateStr,
                        salary: salaryValue,
                        compensationType: compensationType,
                        location: location.isEmpty ? nil : location,
                        openings: openings
                    )
                } else {
                    position = try await APIService.shared.createFacilityPosition(
                        token: token,
                        title: title.trimmingCharacters(in: .whitespaces),
                        profession: profession,
                        description: positionDescription.isEmpty ? nil : positionDescription,
                        requirements: requirements.isEmpty ? nil : requirements,
                        startDate: startDateStr,
                        endDate: endDateStr,
                        salary: salaryValue,
                        compensationType: compensationType,
                        location: location.isEmpty ? nil : location,
                        openings: openings
                    )
                }
                await MainActor.run {
                    isLoading = false
                    onCreated(position)
                    dismiss()
                }
            } catch let error as APIError {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = isEditing ? "Failed to update position. Please try again." : "Failed to create position. Please try again."
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    CreatePositionView(onCreated: { _ in })
}
