//
//  ApplyNowView.swift
//  YolkuApp
//
//  Shown when a healthcare worker taps "Apply Now" on a position.
//  Auto-populates contact info, credentials, state licenses,
//  board certifications, and attached documents from the worker's profile.
//

import SwiftUI

// MARK: - Apply Now View

struct ApplyNowView: View {
    let position: Position
    @Environment(\.dismiss) var dismiss

    // Contact info (auto-pulled from profile)
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""

    // Credentials (auto-pulled from profile)
    @State private var credentials: [String] = []

    // State Licenses (auto-pulled from profile)
    @State private var stateLicenses: [StateLicense] = []

    // Board Certifications (auto-pulled from profile)
    @State private var boardCertifications: [BoardCertification] = []

    // Documents (auto-pulled from uploaded documents)
    @State private var attachedDocuments: [Document] = []

    // UI state
    @State private var showSubmitAlert = false
    @State private var isSubmitting = false
    @State private var missingInfoAlert = false

    // Documents relevant to a job application
    private let applicationDocumentTypes: Set<DocumentType> = [
        .medicalLicense,
        .nursingLicense,
        .dea,
        .certification,
        .resume
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: Position Summary Banner
                    positionSummaryCard

                    // MARK: Contact Information
                    ApplySectionCard(title: "Contact Information", icon: "person.fill") {
                        VStack(spacing: 10) {
                            ApplyInfoRow(label: "Name", value: fullName)
                            ApplyInfoRow(label: "Email", value: email.isEmpty ? "Not provided" : email)
                            ApplyInfoRow(label: "Phone", value: phone.isEmpty ? "Not provided" : phone)
                            ApplyInfoRow(label: "Address", value: address.isEmpty ? "Not provided" : address)
                        }
                    }

                    // MARK: Credentials
                    if !credentials.isEmpty {
                        ApplySectionCard(title: "Credentials", icon: "rosette") {
                            FlowLayout(items: credentials) { credential in
                                Text(credential)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(Color(hex: "667eea"))
                                    .cornerRadius(8)
                            }
                        }
                    }

                    // MARK: State Licenses (Medical Licenses)
                    if !stateLicenses.isEmpty {
                        ApplySectionCard(title: "State Medical Licenses", icon: "cross.case.fill") {
                            VStack(spacing: 8) {
                                ForEach(stateLicenses) { license in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(license.state)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color(hex: "333333"))
                                            if !license.licenseNumber.isEmpty {
                                                Text(license.licenseNumber)
                                                    .font(.system(size: 13))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    .padding(10)
                                    .background(Color(hex: "f8f9fa"))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }

                    // MARK: Board Certifications
                    if !boardCertifications.isEmpty {
                        ApplySectionCard(title: "Board Certifications", icon: "checkmark.seal.fill") {
                            VStack(spacing: 8) {
                                ForEach(boardCertifications) { cert in
                                    HStack {
                                        Text(cert.name.isEmpty ? "Unnamed certification" : cert.name)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(hex: "333333"))
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    .padding(10)
                                    .background(Color(hex: "f8f9fa"))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }

                    // MARK: Attached Documents
                    ApplySectionCard(title: "Attached Documents", icon: "paperclip") {
                        if attachedDocuments.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "doc.badge.exclamationmark")
                                    .font(.system(size: 36))
                                    .foregroundColor(Color(hex: "667eea").opacity(0.4))
                                Text("No documents uploaded yet")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Text("Upload your medical license, DEA certificate, CV/resume, and certifications from your Profile → Documents & Licenses.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(attachedDocuments) { document in
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(document.type.color.opacity(0.12))
                                                .frame(width: 38, height: 38)
                                            Image(systemName: document.type.icon)
                                                .font(.system(size: 18))
                                                .foregroundColor(document.type.color)
                                        }
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(document.name)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(hex: "333333"))
                                                .lineLimit(1)
                                            Text(document.type.rawValue)
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    .padding(10)
                                    .background(Color(hex: "f8f9fa"))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }

                    // MARK: Submit Button
                    Button(action: submitApplication) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.trailing, 4)
                            }
                            Text(isSubmitting ? "Submitting…" : "Submit Application")
                                .font(.system(size: 17, weight: .semibold))
                        }
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
                        .shadow(color: Color(hex: "667eea").opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isSubmitting)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .padding(.top, 16)
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Apply for Position")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(hex: "667eea"))
                }
            }
            .alert("Application Submitted!", isPresented: $showSubmitAlert) {
                Button("Done") { dismiss() }
            } message: {
                Text("Your application for \(position.title) at \(position.facility.name) has been submitted. The facility will be in touch soon.")
            }
            .alert("Incomplete Profile", isPresented: $missingInfoAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please complete your profile with contact information before applying.")
            }
            .onAppear {
                loadProfileData()
                loadDocuments()
            }
        }
    }

    // MARK: - Position Summary Card

    private var positionSummaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(position.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "333333"))
                    Text(position.facility.name)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "667eea"))
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(position.facility.location)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(position.formattedRate)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "667eea"))
                    Text(position.formattedDate)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        .padding(.horizontal, 20)
    }

    // MARK: - Helpers

    private var fullName: String {
        let name = [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
        return name.isEmpty ? "Not provided" : name
    }

    // MARK: - Data Loading

    private func loadProfileData() {
        firstName = UserDefaults.standard.string(forKey: "profileFirstName")
            ?? UserDefaults.standard.string(forKey: "userFirstName") ?? ""
        lastName = UserDefaults.standard.string(forKey: "profileLastName") ?? ""
        email = UserDefaults.standard.string(forKey: "profileEmail")
            ?? UserDefaults.standard.string(forKey: "userEmail") ?? ""
        phone = UserDefaults.standard.string(forKey: "profilePhone") ?? ""
        address = UserDefaults.standard.string(forKey: "profileAddress") ?? ""
        credentials = UserDefaults.standard.stringArray(forKey: "profileCredentials") ?? []

        if let data = UserDefaults.standard.data(forKey: "profileStateLicenses"),
           let decoded = try? JSONDecoder().decode([StateLicense].self, from: data) {
            stateLicenses = decoded.filter { !$0.state.isEmpty }
        }

        if let data = UserDefaults.standard.data(forKey: "profileBoardCertifications"),
           let decoded = try? JSONDecoder().decode([BoardCertification].self, from: data) {
            boardCertifications = decoded.filter { !$0.name.isEmpty }
        }
    }

    private func loadDocuments() {
        guard let data = UserDefaults.standard.data(forKey: "uploadedDocuments"),
              let all = try? JSONDecoder().decode([Document].self, from: data) else { return }
        attachedDocuments = all.filter { applicationDocumentTypes.contains($0.type) }
    }

    // MARK: - Submit

    private func submitApplication() {
        guard !firstName.isEmpty && !email.isEmpty else {
            missingInfoAlert = true
            return
        }
        isSubmitting = true
        // Simulate async submission (replace with real API call when endpoint exists)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isSubmitting = false
            showSubmitAlert = true
        }
    }
}

// MARK: - Apply Section Card (local lightweight version)

private struct ApplySectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "667eea"))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "333333"))
            }
            content()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}

// MARK: - Apply Info Row

private struct ApplyInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "999999"))
                .frame(width: 64, alignment: .leading)
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "333333"))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Flow Layout (wrapping chip layout for credentials)

private struct FlowLayout<Item: Hashable, ItemView: View>: View {
    let items: [Item]
    @ViewBuilder let itemView: (Item) -> ItemView

    private var rows: [[Item]] {
        var result: [[Item]] = [[]]
        for (index, item) in items.enumerated() {
            if index % 4 == 0 && index != 0 {
                result.append([])
            }
            result[result.count - 1].append(item)
        }
        return result
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { item in
                        itemView(item)
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ApplyNowView(
        position: Position(
            id: "1",
            facility: Facility(id: "f1", name: "Memorial Hospital", city: "Austin", state: "TX", facilityType: "Hospital"),
            title: "Registered Nurse",
            profession: "RN",
            shiftDate: "2026-04-01",
            shiftStartTime: "07:00:00",
            shiftEndTime: "19:00:00",
            hourlyRate: 65,
            openings: 2
        )
    )
}
