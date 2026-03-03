//
//  AIJobMatcherView.swift
//  YolkuApp
//
//  AI-powered job matching: scans open positions and surfaces the best
//  matches for the current user's profession and preferences.
//

import SwiftUI

struct AIJobMatcherView: View {
    @AppStorage("userProfession") private var userProfession = ""
    @AppStorage("authToken") private var authToken = ""

    @State private var profession: String = ""
    @State private var preferredState: String = ""
    @State private var minSalaryText: String = ""
    @State private var matches: [AIMatchedPosition] = []
    @State private var totalScanned: Int = 0
    @State private var isLoading = false
    @State private var hasSearched = false
    @State private var errorMessage: String?
    @State private var showFilters = false

    private let professions = ["RN", "LPN", "CNA", "Doctor", "PA", "NP", "Therapist", "Pharmacist", "Other"]
    private let states = ["", "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA",
                          "KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
                          "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT",
                          "VA","WA","WV","WI","WY"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero header
                    aiHeader

                    // Filter card
                    filterCard

                    // Results
                    if isLoading {
                        ProgressView("Scanning positions…")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else if hasSearched && matches.isEmpty {
                        emptyState
                    } else if !matches.isEmpty {
                        resultsSection
                    }

                    Spacer(minLength: 40)
                }
                .padding(.bottom, 20)
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("AI Job Matcher")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK") { errorMessage = nil }
            }, message: {
                Text(errorMessage ?? "")
            })
            .onAppear {
                if profession.isEmpty {
                    profession = userProfession.isEmpty ? "RN" : userProfession
                }
            }
        }
    }

    // MARK: - Subviews

    private var aiHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea").opacity(0.15), Color(hex: "764ba2").opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 36))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            Text("AI-Powered Matching")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "333333"))
            Text("Scans open positions across all facilities and ranks them by how well they match your profile.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.top, 20)
    }

    private var filterCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Profile")
                .font(.headline)
                .foregroundColor(Color(hex: "333333"))

            // Profession picker
            VStack(alignment: .leading, spacing: 6) {
                Text("Profession")
                    .font(.caption)
                    .foregroundColor(.gray)
                Picker("Profession", selection: $profession) {
                    ForEach(professions, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(10)
                .background(Color(hex: "f5f5f5"))
                .cornerRadius(8)
            }

            // Preferred state picker
            VStack(alignment: .leading, spacing: 6) {
                Text("Preferred State (optional)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Picker("State", selection: $preferredState) {
                    Text("Any State").tag("")
                    ForEach(states.dropFirst(), id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(10)
                .background(Color(hex: "f5f5f5"))
                .cornerRadius(8)
            }

            // Minimum salary
            VStack(alignment: .leading, spacing: 6) {
                Text("Minimum Salary (optional)")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("e.g. 60000", text: $minSalaryText)
                    .keyboardType(.numberPad)
                    .padding(10)
                    .background(Color(hex: "f5f5f5"))
                    .cornerRadius(8)
            }

            // Run button
            Button(action: {
                Task { await runAIMatch() }
            }) {
                HStack {
                    Image(systemName: "sparkles")
                    Text(isLoading ? "Scanning…" : "Find My Matches")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isLoading)
            .opacity(isLoading ? 0.7 : 1)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(hex: "667eea"))
                Text("\(matches.count) matches found")
                    .font(.headline)
                    .foregroundColor(Color(hex: "333333"))
                Spacer()
                Text("\(totalScanned) positions scanned")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)

            ForEach(matches) { match in
                AIMatchCard(match: match)
                    .padding(.horizontal, 16)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "667eea").opacity(0.4))
            Text("No matches found")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "333333"))
            Text("Try adjusting your filters or check back later for new openings.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
        .padding(.horizontal, 32)
    }

    // MARK: - Actions

    private func runAIMatch() async {
        isLoading = true
        hasSearched = false
        errorMessage = nil
        do {
            let minSalary: Double? = minSalaryText.isEmpty ? nil : Double(minSalaryText)
            let stateParam = preferredState.isEmpty ? nil : preferredState
            let response = try await APIService.shared.getAIMatches(
                profession: profession,
                preferredState: stateParam,
                minSalary: minSalary
            )
            matches = response.data
            totalScanned = response.totalScanned
            hasSearched = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - Match Card

struct AIMatchCard: View {
    let match: AIMatchedPosition

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header row
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(match.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                    Text(match.facility.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(match.facility.city), \(match.facility.state)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                MatchScoreBadge(score: match.matchScore)
            }

            Divider()

            // Details row
            HStack(spacing: 16) {
                Label(match.profession, systemImage: "stethoscope")
                    .font(.caption)
                    .foregroundColor(Color(hex: "667eea"))
                Label(match.formattedSalary, systemImage: "dollarsign.circle")
                    .font(.caption)
                    .foregroundColor(Color(hex: "764ba2"))
                Label(match.formattedStartDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            // Match reasons
            VStack(alignment: .leading, spacing: 4) {
                ForEach(match.matchReasons, id: \.self) { reason in
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "667eea"))
                        Text(reason)
                            .font(.caption)
                            .foregroundColor(Color(hex: "555555"))
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Match Score Badge

struct MatchScoreBadge: View {
    let score: Int

    private var badgeColor: Color {
        if score >= 80 { return Color(hex: "34c759") }
        if score >= 50 { return Color(hex: "667eea") }
        return Color.gray
    }

    var body: some View {
        VStack(spacing: 2) {
            Text("\(score)%")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(badgeColor)
            Text("match")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .frame(width: 52, height: 44)
        .background(badgeColor.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    AIJobMatcherView()
}
