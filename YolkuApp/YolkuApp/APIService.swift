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
