//
//  JobDatabase.swift
//  YolkuApp
//
//  A lightweight UserDefaults-backed persistent store for job positions.
//  Healthcare facilities write to this store when they create or delete
//  positions; healthcare workers read from it when browsing available jobs.
//

import Foundation

// MARK: - Stored Job Position

/// A job position as persisted in the local database.
/// Bundles the full `FacilityPosition` record together with the
/// originating facility's display information so workers can see
/// facility details without a separate lookup.
struct StoredJobPosition: Codable, Identifiable {
    let position: FacilityPosition
    let facilityName: String
    let facilityCity: String
    let facilityState: String
    let facilityType: String

    var id: String { position.id }
}

// MARK: - Job Database

/// Manages persistence of job positions in `UserDefaults`.
///
/// Usage:
/// ```swift
/// // Facility saves a new position
/// JobDatabase.shared.save(StoredJobPosition(position: fp, ...))
///
/// // Facility lists its own positions
/// let mine = JobDatabase.shared.positions(forFacilityId: "abc123")
///
/// // Worker browses all open positions
/// let all = JobDatabase.shared.allPositions()
///
/// // Facility removes a position
/// JobDatabase.shared.delete(id: "abc123")
/// ```
class JobDatabase {
    static let shared = JobDatabase()

    private let storageKey = "yolku_job_database"
    private let seededKey  = "yolku_job_database_seeded"

    private init() {
        if !UserDefaults.standard.bool(forKey: seededKey) {
            seedInitialPositions()
            UserDefaults.standard.set(true, forKey: seededKey)
        }
    }

    // MARK: - Public API

    /// All positions in the database, newest first.
    func allPositions() -> [StoredJobPosition] {
        loadAll()
    }

    /// Positions belonging to a specific facility, newest first.
    func positions(forFacilityId facilityId: String) -> [StoredJobPosition] {
        loadAll().filter { $0.position.facilityId == facilityId }
    }

    /// Persist a new (or updated) position.
    /// If a position with the same `id` already exists it is replaced.
    func save(_ storedPosition: StoredJobPosition) {
        var all = loadAll()
        all.removeAll { $0.id == storedPosition.id }
        all.insert(storedPosition, at: 0)
        persist(all)
    }

    /// Remove a position by its id.
    func delete(id: String) {
        var all = loadAll()
        all.removeAll { $0.id == id }
        persist(all)
    }

    // MARK: - Private helpers

    private func loadAll() -> [StoredJobPosition] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let positions = try? JSONDecoder().decode([StoredJobPosition].self, from: data) else {
            return []
        }
        return positions
    }

    private func persist(_ positions: [StoredJobPosition]) {
        if let data = try? JSONEncoder().encode(positions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - Seed data

    /// Populates the database with representative demo positions the first
    /// time the app launches, so healthcare workers immediately have jobs to
    /// browse before any real facility has created one.
    private func seedInitialPositions() {
        let isoFmt = ISO8601DateFormatter()
        let now = isoFmt.string(from: Date())
        func date(daysAhead: Int) -> String {
            let target = Calendar.current.date(byAdding: .day, value: daysAhead, to: Date()) ?? Date()
            return isoFmt.string(from: target)
        }

        let seeds: [StoredJobPosition] = [
            StoredJobPosition(
                position: FacilityPosition(
                    id: "seed-pos-1",
                    facilityId: "seed-facility-1",
                    title: "RN – ICU Day Shift",
                    profession: "RN",
                    description: "Seeking an experienced RN for day shift in the ICU.",
                    requirements: "Active RN license. Minimum 2 years ICU experience.",
                    startDate: date(daysAhead: 7), endDate: nil,
                    salary: 85000, compensationType: "annual_salary",
                    location: "San Francisco, CA",
                    openings: 2, status: "Open",
                    createdAt: now, updatedAt: now
                ),
                facilityName: "General Hospital",
                facilityCity: "San Francisco",
                facilityState: "CA",
                facilityType: "Hospital"
            ),
            StoredJobPosition(
                position: FacilityPosition(
                    id: "seed-pos-2",
                    facilityId: "seed-facility-2",
                    title: "CNA – Night Shift",
                    profession: "CNA",
                    description: "Certified Nursing Assistant needed for overnight care.",
                    requirements: "Current CNA certification required.",
                    startDate: date(daysAhead: 10), endDate: nil,
                    salary: 22, compensationType: "hourly_rate",
                    location: "Los Angeles, CA",
                    openings: 3, status: "Open",
                    createdAt: now, updatedAt: now
                ),
                facilityName: "City Medical Center",
                facilityCity: "Los Angeles",
                facilityState: "CA",
                facilityType: "Hospital"
            ),
            StoredJobPosition(
                position: FacilityPosition(
                    id: "seed-pos-3",
                    facilityId: "seed-facility-3",
                    title: "LPN – Long-Term Care",
                    profession: "LPN",
                    description: "LPN needed for long-term care facility.",
                    requirements: "Valid LPN license. Experience in elder care preferred.",
                    startDate: date(daysAhead: 14), endDate: nil,
                    salary: 65000, compensationType: "annual_salary",
                    location: "Sacramento, CA",
                    openings: 3, status: "Open",
                    createdAt: now, updatedAt: now
                ),
                facilityName: "Community Nursing Home",
                facilityCity: "Sacramento",
                facilityState: "CA",
                facilityType: "Nursing Home"
            ),
            StoredJobPosition(
                position: FacilityPosition(
                    id: "seed-pos-4",
                    facilityId: "seed-facility-4",
                    title: "NP – Primary Care",
                    profession: "NP",
                    description: "Nurse Practitioner for a busy primary-care clinic.",
                    requirements: "Current NP license. DEA number preferred.",
                    startDate: date(daysAhead: 21), endDate: nil,
                    salary: 110000, compensationType: "annual_salary",
                    location: "New York, NY",
                    openings: 1, status: "Open",
                    createdAt: now, updatedAt: now
                ),
                facilityName: "NYC Healthcare Center",
                facilityCity: "New York",
                facilityState: "NY",
                facilityType: "Clinic"
            ),
            StoredJobPosition(
                position: FacilityPosition(
                    id: "seed-pos-5",
                    facilityId: "seed-facility-5",
                    title: "PA – Urgent Care",
                    profession: "PA",
                    description: "Physician Assistant for fast-paced urgent care setting.",
                    requirements: "PA-C certification required. BLS/ACLS preferred.",
                    startDate: date(daysAhead: 28), endDate: nil,
                    salary: 450, compensationType: "daily_rate",
                    location: "San Diego, CA",
                    openings: 2, status: "Open",
                    createdAt: now, updatedAt: now
                ),
                facilityName: "Sunset Urgent Care",
                facilityCity: "San Diego",
                facilityState: "CA",
                facilityType: "Urgent Care"
            ),
            StoredJobPosition(
                position: FacilityPosition(
                    id: "seed-pos-6",
                    facilityId: "seed-facility-6",
                    title: "RN – Med/Surg Night Shift",
                    profession: "RN",
                    description: "Med/Surg RN for evening and overnight rotations.",
                    requirements: "Active RN license. 1 year med/surg experience preferred.",
                    startDate: date(daysAhead: 5), endDate: nil,
                    salary: 78000, compensationType: "annual_salary",
                    location: "Austin, TX",
                    openings: 4, status: "Open",
                    createdAt: now, updatedAt: now
                ),
                facilityName: "Austin Medical Clinic",
                facilityCity: "Austin",
                facilityState: "TX",
                facilityType: "Clinic"
            ),
        ]

        seeds.forEach { save($0) }
    }
}
