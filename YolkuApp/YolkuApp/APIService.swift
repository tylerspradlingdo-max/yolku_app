//
//  APIService.swift
//  YolkuApp
//
//  API Service for authentication and user management
//

import Foundation

// MARK: - API Service

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    // MARK: - Authentication
    
    func signIn(email: String, password: String) async throws -> AuthResponse {
        // Mock mode - return fake success response without server
        if APIConfig.useMockMode {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // Return mock successful sign in
            return AuthResponse(
                message: "Sign in successful! (Mock Mode)",
                token: "mock_token_\(UUID().uuidString)",
                user: User(
                    id: UUID().uuidString,
                    firstName: "Demo",
                    lastName: "User",
                    email: email,
                    phoneNumber: "555-0123",
                    profession: "RN",
                    licenseNumber: "RN123456",
                    isVerified: true,
                    isActive: true,
                    lastLogin: ISO8601DateFormatter().string(from: Date()),
                    createdAt: ISO8601DateFormatter().string(from: Date()),
                    updatedAt: ISO8601DateFormatter().string(from: Date())
                )
            )
        }
        
        // Real API mode - connect to server
        guard let url = URL(string: APIConfig.Auth.signIn) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = SignInRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(errorResponse.error)
            }
            throw APIError.serverError("Sign in failed with status code: \(httpResponse.statusCode)")
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phoneNumber: String?,
        profession: String,
        licenseNumber: String?
    ) async throws -> AuthResponse {
        // Mock mode - return fake success response without server
        if APIConfig.useMockMode {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            // Return mock successful sign up
            return AuthResponse(
                message: "Account created successfully! (Mock Mode)",
                token: "mock_token_\(UUID().uuidString)",
                user: User(
                    id: UUID().uuidString,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber,
                    profession: profession,
                    licenseNumber: licenseNumber,
                    isVerified: false,
                    isActive: true,
                    lastLogin: nil,
                    createdAt: ISO8601DateFormatter().string(from: Date()),
                    updatedAt: ISO8601DateFormatter().string(from: Date())
                )
            )
        }
        
        // Real API mode - connect to server
        guard let url = URL(string: APIConfig.Auth.signUp) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = SignUpRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            profession: profession,
            licenseNumber: licenseNumber
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(errorResponse.error)
            }
            throw APIError.serverError("Sign up failed with status code: \(httpResponse.statusCode)")
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func getProfile(token: String) async throws -> User {
        // Mock mode - return fake user profile
        if APIConfig.useMockMode {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            // Return mock user profile
            return User(
                id: UUID().uuidString,
                firstName: "Demo",
                lastName: "User",
                email: "demo@yolku.com",
                phoneNumber: "555-0123",
                profession: "RN",
                licenseNumber: "RN123456",
                isVerified: true,
                isActive: true,
                lastLogin: ISO8601DateFormatter().string(from: Date()),
                createdAt: ISO8601DateFormatter().string(from: Date()),
                updatedAt: ISO8601DateFormatter().string(from: Date())
            )
        }
        
        // Real API mode - connect to server
        guard let url = URL(string: APIConfig.Users.profile) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        let profileResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
        return profileResponse.user
    }
    
    // MARK: - Positions
    
    func getPositions(state: String? = nil, startDate: String? = nil, endDate: String? = nil, profession: String? = nil) async throws -> [Position] {
        // Mock mode - return fake positions
        if APIConfig.useMockMode {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
            
            // Generate mock positions
            return generateMockPositions(state: state, startDate: startDate, endDate: endDate, profession: profession)
        }
        
        // Real API mode - connect to server
        var urlComponents = URLComponents(string: APIConfig.Positions.list)
        var queryItems: [URLQueryItem] = []
        
        if let state = state {
            queryItems.append(URLQueryItem(name: "state", value: state))
        }
        if let startDate = startDate {
            queryItems.append(URLQueryItem(name: "startDate", value: startDate))
        }
        if let endDate = endDate {
            queryItems.append(URLQueryItem(name: "endDate", value: endDate))
        }
        if let profession = profession {
            queryItems.append(URLQueryItem(name: "profession", value: profession))
        }
        
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Failed to fetch positions")
        }
        
        let positionsResponse = try JSONDecoder().decode(PositionsResponse.self, from: data)
        return positionsResponse.data
    }
    
    func getAvailableStates() async throws -> [String] {
        // Mock mode - return fake states
        if APIConfig.useMockMode {
            return ["CA", "NY", "TX", "FL", "IL"]
        }
        
        // Real API mode
        guard let url = URL(string: APIConfig.Positions.states) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Failed to fetch states")
        }
        
        let statesResponse = try JSONDecoder().decode(StatesResponse.self, from: data)
        return statesResponse.data
    }
    
    // Helper to generate mock positions
    private func generateMockPositions(state: String?, startDate: String?, endDate: String?, profession: String?) -> [Position] {
        let facilities = [
            Facility(id: "1", name: "General Hospital", city: "San Francisco", state: "CA", facilityType: "Hospital"),
            Facility(id: "2", name: "City Medical Center", city: "Los Angeles", state: "CA", facilityType: "Hospital"),
            Facility(id: "3", name: "Community Nursing Home", city: "Sacramento", state: "CA", facilityType: "Nursing Home"),
            Facility(id: "4", name: "NYC Healthcare Center", city: "New York", state: "NY", facilityType: "Hospital"),
            Facility(id: "5", name: "Sunset Urgent Care", city: "San Diego", state: "CA", facilityType: "Urgent Care"),
            Facility(id: "6", name: "Austin Medical Clinic", city: "Austin", state: "TX", facilityType: "Clinic")
        ]
        
        let professions = ["RN", "LPN", "CNA", "NP", "PA", "Therapist"]
        let today = Date()
        var positions: [Position] = []
        
        for i in 0..<20 {
            let randomFacility = facilities.randomElement()!
            let randomProfession = professions.randomElement()!
            let daysAhead = Int.random(in: 0...30)
            let shiftDate = Calendar.current.date(byAdding: .day, value: daysAhead, to: today)!
            
            // Apply filters
            if let filterState = state, randomFacility.state != filterState {
                continue
            }
            if let filterProfession = profession, randomProfession != filterProfession {
                continue
            }
            
            let position = Position(
                id: "mock-\(i)",
                facility: randomFacility,
                title: "\(randomProfession) - \(["Day", "Night", "Evening"].randomElement()!) Shift",
                profession: randomProfession,
                shiftDate: ISO8601DateFormatter().string(from: shiftDate).split(separator: "T").first.map(String.init) ?? "",
                shiftStartTime: ["07:00:00", "15:00:00", "19:00:00"].randomElement()!,
                shiftEndTime: ["15:00:00", "23:00:00", "07:00:00"].randomElement()!,
                hourlyRate: Double.random(in: 25...85),
                openings: Int.random(in: 1...3)
            )
            positions.append(position)
        }
        
        return positions.sorted { $0.shiftDate < $1.shiftDate }
    }
}

// MARK: - Request Models

struct SignInRequest: Codable {
    let email: String
    let password: String
}

struct SignUpRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let phoneNumber: String?
    let profession: String
    let licenseNumber: String?
}

// MARK: - Response Models

struct AuthResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct ProfileResponse: Codable {
    let user: User
}

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    let profession: String
    let licenseNumber: String?
    let isVerified: Bool
    let isActive: Bool
    let lastLogin: String?
    let createdAt: String
    let updatedAt: String
}

struct ErrorResponse: Codable {
    let error: String
}

// MARK: - Position Models

struct PositionsResponse: Codable {
    let success: Bool
    let count: Int
    let data: [Position]
}

struct StatesResponse: Codable {
    let success: Bool
    let data: [String]
}

struct Position: Codable, Identifiable {
    let id: String
    let facility: Facility
    let title: String
    let profession: String
    let shiftDate: String
    let shiftStartTime: String
    let shiftEndTime: String
    let hourlyRate: Double
    let openings: Int
    
    var formattedRate: String {
        return String(format: "$%.0f/hr", hourlyRate)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: shiftDate) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        return shiftDate
    }
    
    var formattedTime: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        var startTimeStr = ""
        var endTimeStr = ""
        
        if let startTime = timeFormatter.date(from: shiftStartTime) {
            timeFormatter.dateFormat = "h:mm a"
            startTimeStr = timeFormatter.string(from: startTime)
        }
        
        if let endTime = timeFormatter.date(from: shiftEndTime) {
            timeFormatter.dateFormat = "h:mm a"
            endTimeStr = timeFormatter.string(from: endTime)
        }
        
        return "\(startTimeStr) - \(endTimeStr)"
    }
}

struct Facility: Codable {
    let id: String
    let name: String
    let city: String
    let state: String
    let facilityType: String
    
    var location: String {
        return "\(city), \(state)"
    }
}

// MARK: - API Errors

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case serverError(String)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidData:
            return "Invalid data received"
        case .serverError(let message):
            return message
        case .networkError:
            return "Network connection error"
        }
    }
}
