//
//  FacilityPositionsView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-03-05.
//

import SwiftUI

struct FacilityPositionsView: View {
    @State private var positions: [FacilityPosition] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingCreatePosition = false
    @State private var showDeleteAlert = false
    @State private var positionToDelete: FacilityPosition?
    @State private var showDeleteErrorAlert = false
    @State private var positionToEdit: FacilityPosition?

    var body: some View {
        NavigationView {
            Group {
                if isLoading && positions.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView("Loading positions…")
                        Spacer()
                    }
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        Button("Retry") { loadPositions() }
                            .buttonStyle(OutlineButtonStyle())
                        Spacer()
                    }
                    .padding()
                } else if positions.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "briefcase")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("No Positions Yet")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "333333"))
                        Text("Create your first position to start\nfinding qualified professionals.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button(action: { showingCreatePosition = true }) {
                            Label("Create Position", systemImage: "plus")
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
                                .cornerRadius(25)
                        }
                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(positions) { position in
                            Button(action: { positionToEdit = position }) {
                                PositionCard(position: position)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    positionToDelete = position
                                    showDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(hex: "f5f5f5"))
                    .refreshable { loadPositions() }
                }
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("My Positions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreatePosition = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(hex: "667eea"))
                    }
                }
            }
            .sheet(isPresented: $showingCreatePosition) {
                CreatePositionView { newPosition in
                    positions.insert(newPosition, at: 0)
                }
            }
            .sheet(item: $positionToEdit) { position in
                CreatePositionView(existingPosition: position) { updatedPosition in
                    if let idx = positions.firstIndex(where: { $0.id == updatedPosition.id }) {
                        positions[idx] = updatedPosition
                    }
                }
            }
            .alert("Delete Position", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let position = positionToDelete {
                        deletePosition(position)
                    }
                }
            } message: {
                Text("Are you sure you want to delete \"\(positionToDelete?.title ?? "this position")\"?")
            }
            .alert("Delete Failed", isPresented: $showDeleteErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Could not delete the position. Please try again.")
            }
            .onAppear { loadPositions() }
        }
    }

    private func loadPositions() {
        isLoading = true
        errorMessage = nil
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        Task {
            do {
                let result = try await APIService.shared.getFacilityPositions(token: token)
                await MainActor.run {
                    positions = result
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to load positions. Please try again."
                    isLoading = false
                }
            }
        }
    }

    private func deletePosition(_ position: FacilityPosition) {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        Task {
            do {
                try await APIService.shared.deleteFacilityPosition(token: token, positionId: position.id)
                await MainActor.run {
                    positions.removeAll { $0.id == position.id }
                }
            } catch {
                await MainActor.run {
                    showDeleteErrorAlert = true
                }
            }
        }
    }
}

// MARK: - Position Card

struct PositionCard: View {
    let position: FacilityPosition

    private var statusColor: Color {
        switch position.status {
        case "Open": return Color(hex: "22c55e")
        case "Filled": return Color(hex: "667eea")
        default: return Color.gray
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(position.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                    Text(position.profession)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "667eea"))
                }
                Spacer()
                Text(position.status)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.12))
                    .cornerRadius(8)
            }

            Divider()

            HStack(spacing: 20) {
                Label(position.formattedSalary, systemImage: "dollarsign.circle.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                Label(position.formattedStartDate, systemImage: "calendar")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                Label("\(position.openings) \(position.openings == 1 ? "opening" : "openings")", systemImage: "person.2.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            if let loc = position.location, !loc.isEmpty {
                Label(loc, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            if let desc = position.description, !desc.isEmpty {
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

#Preview {
    FacilityPositionsView()
}
