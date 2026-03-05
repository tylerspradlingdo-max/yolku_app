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
    
    func facilitySignIn(email: String, password: String) async throws -> FacilityAuthResponse {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return FacilityAuthResponse(
                message: "Signed in successfully (Mock Mode)",
                token: "mock_facility_token_\(UUID().uuidString)",
                facility: FacilityData(
                    id: UUID().uuidString,
                    name: "Demo Medical Center",
                    email: email,
                    address: "123 Main St",
                    city: "San Francisco",
                    state: "CA",
                    zipCode: "94102",
                    phoneNumber: "555-0199",
                    facilityType: "Hospital",
                    description: "A demo healthcare facility.",
                    isActive: true,
                    createdAt: ISO8601DateFormatter().string(from: Date()),
                    updatedAt: ISO8601DateFormatter().string(from: Date())
                )
            )
        }

        guard let url = URL(string: APIConfig.Facilities.signIn) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(SignInRequest(email: email, password: password))

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(errorResponse.error)
            }
            throw APIError.serverError("Facility sign in failed with status code: \(httpResponse.statusCode)")
        }
        let facilityResponse = try JSONDecoder().decode(FacilitySignInAPIResponse.self, from: data)
        return FacilityAuthResponse(
            message: facilityResponse.message,
            token: facilityResponse.data.token,
            facility: facilityResponse.data.facility
        )
    }

    func getFacilityPositions(token: String) async throws -> [FacilityPosition] {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 500_000_000)
            return generateMockFacilityPositions()
        }
        guard let url = URL(string: APIConfig.Facilities.positions) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        let result = try JSONDecoder().decode(FacilityPositionsResponse.self, from: data)
        return result.data
    }

    func createFacilityPosition(
        token: String,
        title: String,
        profession: String,
        description: String?,
        requirements: String?,
        startDate: String,
        endDate: String?,
        salary: Double,
        location: String?,
        openings: Int
    ) async throws -> FacilityPosition {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 800_000_000)
            let now = ISO8601DateFormatter().string(from: Date())
            return FacilityPosition(
                id: UUID().uuidString,
                facilityId: "mock-facility-id",
                title: title,
                profession: profession,
                description: description,
                requirements: requirements,
                startDate: startDate,
                endDate: endDate,
                salary: salary,
                location: location,
                openings: openings,
                status: "Open",
                createdAt: now,
                updatedAt: now
            )
        }
        guard let url = URL(string: APIConfig.Facilities.positions) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body = CreatePositionRequest(
            title: title,
            profession: profession,
            description: description,
            requirements: requirements,
            startDate: startDate,
            endDate: endDate,
            salary: salary,
            location: location,
            openings: openings
        )
        request.httpBody = try JSONEncoder().encode(body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(errorResponse.error)
            }
            throw APIError.serverError("Failed to create position")
        }
        let result = try JSONDecoder().decode(FacilityPositionResponse.self, from: data)
        return result.data
    }

    func deleteFacilityPosition(token: String, positionId: String) async throws {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 300_000_000)
            return
        }
        guard let url = URL(string: APIConfig.Facilities.position(id: positionId)) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Failed to delete position")
        }
    }

    private func generateMockFacilityPositions() -> [FacilityPosition] {
        let now = ISO8601DateFormatter().string(from: Date())
        let isoFormatter = ISO8601DateFormatter()
        let startDate1 = isoFormatter.string(from: Calendar.current.date(byAdding: .day, value: 7, to: Date())!)
        let startDate2 = isoFormatter.string(from: Calendar.current.date(byAdding: .day, value: 14, to: Date())!)
        return [
            FacilityPosition(
                id: "mock-fpos-1",
                facilityId: "mock-facility-id",
                title: "RN - Day Shift",
                profession: "RN",
                description: "Seeking an experienced RN for day shift in the ICU.",
                requirements: "Active RN license. Minimum 2 years experience.",
                startDate: startDate1,
                endDate: nil,
                salary: 85000,
                location: "San Francisco, CA",
                openings: 2,
                status: "Open",
                createdAt: now,
                updatedAt: now
            ),
            FacilityPosition(
                id: "mock-fpos-2",
                facilityId: "mock-facility-id",
                title: "CNA - Night Shift",
                profession: "CNA",
                description: "Certified Nursing Assistant needed for overnight care.",
                requirements: "Current CNA certification required.",
                startDate: startDate2,
                endDate: nil,
                salary: 45000,
                location: "San Francisco, CA",
                openings: 1,
                status: "Open",
                createdAt: now,
                updatedAt: now
            )
        ]
    }

    func facilitySignUp(
        name: String,
        email: String,
        password: String,
        address: String,
        city: String,
        state: String,
        zipCode: String,
        phoneNumber: String?,
        facilityType: String,
        description: String?
    ) async throws -> FacilityAuthResponse {
        // Mock mode - return fake success response without server
        if APIConfig.useMockMode {
            // Simulate network delay (1.5 seconds)
            try await Task.sleep(nanoseconds: UInt64(1.5 * 1_000_000_000))
            
            // Return mock successful facility sign up
            return FacilityAuthResponse(
                message: "Facility account created successfully! (Mock Mode)",
                token: "mock_facility_token_\(UUID().uuidString)",
                facility: FacilityData(
                    id: UUID().uuidString,
                    name: name,
                    email: email,
                    address: address,
                    city: city,
                    state: state,
                    zipCode: zipCode,
                    phoneNumber: phoneNumber,
                    facilityType: facilityType,
                    description: description,
                    isActive: true,
                    createdAt: ISO8601DateFormatter().string(from: Date()),
                    updatedAt: ISO8601DateFormatter().string(from: Date())
                )
            )
        }
        
        // Real API mode - connect to server
        guard let url = URL(string: "\(APIConfig.baseURL)/api/facilities/signup") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = FacilitySignUpRequest(
            name: name,
            email: email,
            password: password,
            address: address,
            city: city,
            state: state,
            zipCode: zipCode,
            phoneNumber: phoneNumber,
            facilityType: facilityType,
            description: description
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
            throw APIError.serverError("Facility sign up failed with status code: \(httpResponse.statusCode)")
        }
        
        let facilityResponse = try JSONDecoder().decode(FacilitySignUpAPIResponse.self, from: data)
        return FacilityAuthResponse(
            message: facilityResponse.message,
            token: facilityResponse.data.token,
            facility: facilityResponse.data.facility
        )
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
    
    // MARK: - Chat / Messaging
    
    func getConversations(token: String) async throws -> [ChatConversation] {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 500_000_000)
            return generateMockConversations()
        }
        
        guard let url = URL(string: APIConfig.Messages.conversations) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        let result = try JSONDecoder().decode(ConversationsResponse.self, from: data)
        return result.data
    }
    
    func getMessages(conversationId: String, token: String) async throws -> ChatConversation {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 300_000_000)
            return generateMockConversationDetail(id: conversationId)
        }
        
        guard let url = URL(string: APIConfig.Messages.conversation(id: conversationId)) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        let result = try JSONDecoder().decode(ConversationResponse.self, from: data)
        return result.data
    }
    
    func sendMessage(conversationId: String, content: String, token: String) async throws -> ChatMessage {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 300_000_000)
            let now = ISO8601DateFormatter().string(from: Date())
            return ChatMessage(
                id: UUID().uuidString,
                conversationId: conversationId,
                senderType: "user",
                senderId: "mock-user-id",
                content: content,
                isRead: false,
                createdAt: now,
                updatedAt: now
            )
        }
        
        guard let url = URL(string: APIConfig.Messages.conversation(id: conversationId)) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(["content": content])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        let result = try JSONDecoder().decode(SendMessageResponse.self, from: data)
        return result.data
    }
    
    func startConversation(facilityId: String, content: String, token: String) async throws -> ChatConversation {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 500_000_000)
            let now = ISO8601DateFormatter().string(from: Date())
            let msg = ChatMessage(
                id: UUID().uuidString,
                conversationId: "mock-conv-new",
                senderType: "user",
                senderId: "mock-user-id",
                content: content,
                isRead: false,
                createdAt: now,
                updatedAt: now
            )
            return ChatConversation(
                id: "mock-conv-new",
                userId: "mock-user-id",
                facilityId: facilityId,
                user: nil,
                facility: ChatFacility(id: facilityId, name: "New Facility", city: "Dallas", state: "TX", facilityType: "Clinic"),
                messages: [msg],
                createdAt: now,
                updatedAt: now
            )
        }
        
        guard let url = URL(string: APIConfig.Messages.conversations) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(["facilityId": facilityId, "content": content])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        let result = try JSONDecoder().decode(StartConversationResponse.self, from: data)
        return result.data.conversation
    }
    
    // MARK: - AI Job Matching

    func getAIMatches(
        profession: String,
        preferredState: String? = nil,
        minSalary: Double? = nil,
        limit: Int = 20
    ) async throws -> AIMatchResponse {
        if APIConfig.useMockMode {
            try await Task.sleep(nanoseconds: 1_200_000_000) // 1.2 seconds
            return generateMockAIMatches(profession: profession, preferredState: preferredState, minSalary: minSalary, limit: limit)
        }

        guard let url = URL(string: APIConfig.AI.match) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = AIMatchRequest(profession: profession, preferredState: preferredState, minSalary: minSalary, limit: limit)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("AI matching request failed")
        }
        return try JSONDecoder().decode(AIMatchResponse.self, from: data)
    }

    private func generateMockAIMatches(profession: String, preferredState: String?, minSalary: Double?, limit: Int) -> AIMatchResponse {
        let allFacilities = [
            Facility(id: "fac-1", name: "General Hospital", city: "San Francisco", state: "CA", facilityType: "Hospital"),
            Facility(id: "fac-2", name: "City Medical Center", city: "Los Angeles", state: "CA", facilityType: "Hospital"),
            Facility(id: "fac-3", name: "Community Nursing Home", city: "Sacramento", state: "CA", facilityType: "Nursing Home"),
            Facility(id: "fac-4", name: "NYC Healthcare Center", city: "New York", state: "NY", facilityType: "Hospital"),
            Facility(id: "fac-5", name: "Sunset Urgent Care", city: "San Diego", state: "CA", facilityType: "Urgent Care"),
            Facility(id: "fac-6", name: "Austin Medical Clinic", city: "Austin", state: "TX", facilityType: "Clinic"),
            Facility(id: "fac-7", name: "Chicago General", city: "Chicago", state: "IL", facilityType: "Hospital"),
            Facility(id: "fac-8", name: "Miami Health Center", city: "Miami", state: "FL", facilityType: "Clinic")
        ]
        let relatedProfessions: [String: [String]] = [
            "RN": ["RN", "LPN", "NP"],
            "LPN": ["LPN", "RN", "CNA"],
            "CNA": ["CNA", "LPN"],
            "NP": ["NP", "RN", "PA"],
            "PA": ["PA", "NP", "Doctor"],
            "Doctor": ["Doctor", "PA", "NP"],
            "Therapist": ["Therapist"],
            "Pharmacist": ["Pharmacist"],
            "Other": ["Other"]
        ]
        let pool = relatedProfessions[profession] ?? [profession]
        let today = Date()
        var positions: [AIMatchedPosition] = []
        let isoFormatter = ISO8601DateFormatter()

        for i in 0..<min(limit, allFacilities.count * 2) {
            let facility = allFacilities[i % allFacilities.count]
            let posProfession = pool[i % pool.count]
            let daysAhead = i * 5
            let startDate = Calendar.current.date(byAdding: .day, value: daysAhead, to: today)!
            let startDateStr = isoFormatter.string(from: startDate).split(separator: "T").first.map(String.init) ?? ""
            let salary = Double(55000 + i * 3000)
            let isExactMatch = posProfession == profession
            let inPreferredState = preferredState == nil || facility.state == preferredState?.uppercased()

            var score = isExactMatch ? 60 : 20
            var reasons: [String] = []
            if isExactMatch {
                reasons.append("Matches your profession (\(profession))")
            } else {
                reasons.append("Related profession (\(posProfession))")
            }
            if inPreferredState {
                score += preferredState != nil ? 20 : 10
                reasons.append("Located in \(facility.state)")
            }
            if let minSalary = minSalary, salary >= minSalary {
                score += 10
                reasons.append("Salary meets your expectation ($\(Int(salary).formatted()))")
            } else if minSalary == nil {
                score += 10
                reasons.append("Salary: $\(Int(salary).formatted())/yr")
            }
            if daysAhead <= 30 {
                score += 10
                reasons.append("Starts within 30 days")
            } else if daysAhead <= 90 {
                score += 5
                reasons.append("Starts within 90 days")
            }
            score = min(score, 100)

            let pos = AIMatchedPosition(
                id: "mock-ai-\(i)",
                facility: facility,
                title: "\(posProfession) - Full Time",
                profession: posProfession,
                description: "Seeking an experienced \(posProfession) for our \(facility.facilityType.lowercased()) team.",
                requirements: "\(posProfession) license required. Minimum 1 year of experience.",
                startDate: startDateStr,
                endDate: nil,
                salary: salary,
                hourlyRate: salary / 2080,
                openings: (i % 3) + 1,
                status: "Open",
                matchScore: score,
                matchReasons: reasons
            )
            positions.append(pos)
        }

        positions.sort { $0.matchScore > $1.matchScore }
        let sliced = Array(positions.prefix(limit))
        return AIMatchResponse(
            success: true,
            profession: profession,
            totalScanned: allFacilities.count * 2,
            matchCount: sliced.count,
            data: sliced
        )
    }
    
    private func generateMockConversations() -> [ChatConversation] {
        let now = ISO8601DateFormatter().string(from: Date())
        let yesterday = ISO8601DateFormatter().string(from: Date(timeIntervalSinceNow: -86400))
        
        return [
            ChatConversation(
                id: "conv-1",
                userId: "mock-user-id",
                facilityId: "fac-1",
                user: nil,
                facility: ChatFacility(id: "fac-1", name: "General Hospital", city: "San Francisco", state: "CA", facilityType: "Hospital"),
                messages: [
                    ChatMessage(id: "msg-1", conversationId: "conv-1", senderType: "facility", senderId: "fac-1",
                                content: "Hi! We have a day shift opening this Friday. Are you available?",
                                isRead: true, createdAt: yesterday, updatedAt: yesterday)
                ],
                createdAt: yesterday,
                updatedAt: yesterday
            ),
            ChatConversation(
                id: "conv-2",
                userId: "mock-user-id",
                facilityId: "fac-2",
                user: nil,
                facility: ChatFacility(id: "fac-2", name: "City Medical Center", city: "Los Angeles", state: "CA", facilityType: "Hospital"),
                messages: [
                    ChatMessage(id: "msg-2", conversationId: "conv-2", senderType: "user", senderId: "mock-user-id",
                                content: "Hello, I am interested in your RN position.",
                                isRead: true, createdAt: now, updatedAt: now)
                ],
                createdAt: now,
                updatedAt: now
            )
        ]
    }
    
    private func generateMockConversationDetail(id: String) -> ChatConversation {
        let now = ISO8601DateFormatter().string(from: Date())
        let earlier = ISO8601DateFormatter().string(from: Date(timeIntervalSinceNow: -3600))
        let yesterday = ISO8601DateFormatter().string(from: Date(timeIntervalSinceNow: -86400))
        
        let messages: [ChatMessage] = [
            ChatMessage(id: "msg-a", conversationId: id, senderType: "user", senderId: "mock-user-id",
                        content: "Hello, I am interested in the open shift at your facility.",
                        isRead: true, createdAt: yesterday, updatedAt: yesterday),
            ChatMessage(id: "msg-b", conversationId: id, senderType: "facility", senderId: "fac-1",
                        content: "Hi! Thanks for reaching out. We have openings on Friday and Saturday. Do either of those work for you?",
                        isRead: true, createdAt: earlier, updatedAt: earlier),
            ChatMessage(id: "msg-c", conversationId: id, senderType: "user", senderId: "mock-user-id",
                        content: "Friday works great for me.",
                        isRead: true, createdAt: now, updatedAt: now)
        ]
        
        return ChatConversation(
            id: id,
            userId: "mock-user-id",
            facilityId: "fac-1",
            user: ChatUser(id: "mock-user-id", firstName: "Demo", lastName: "User", profession: "RN"),
            facility: ChatFacility(id: "fac-1", name: "General Hospital", city: "San Francisco", state: "CA", facilityType: "Hospital"),
            messages: messages,
            createdAt: yesterday,
            updatedAt: now
        )
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

struct FacilitySignUpRequest: Codable {
    let name: String
    let email: String
    let password: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let phoneNumber: String?
    let facilityType: String
    let description: String?
}

struct CreatePositionRequest: Codable {
    let title: String
    let profession: String
    let description: String?
    let requirements: String?
    let startDate: String
    let endDate: String?
    let salary: Double
    let location: String?
    let openings: Int
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

// MARK: - Facility Models

struct FacilityAuthResponse: Codable {
    let message: String
    let token: String
    let facility: FacilityData
}

struct FacilitySignUpAPIResponse: Codable {
    let success: Bool
    let message: String
    let data: FacilitySignUpData
}

struct FacilitySignInAPIResponse: Codable {
    let success: Bool
    let message: String
    let data: FacilitySignUpData
}

struct FacilitySignUpData: Codable {
    let facility: FacilityData
    let token: String
}

struct FacilityData: Codable {
    let id: String
    let name: String
    let email: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let phoneNumber: String?
    let facilityType: String
    let description: String?
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
}

// MARK: - Facility Position Models

struct FacilityPosition: Codable, Identifiable {
    let id: String
    let facilityId: String?
    let title: String
    let profession: String
    let description: String?
    let requirements: String?
    let startDate: String
    let endDate: String?
    let salary: Double
    let location: String?
    let openings: Int
    let status: String
    let createdAt: String
    let updatedAt: String

    var formattedSalary: String {
        String(format: "$%.0f/yr", salary)
    }

    var formattedStartDate: String {
        let isoFmt = ISO8601DateFormatter()
        isoFmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = isoFmt.date(from: startDate) ?? {
            isoFmt.formatOptions = [.withInternetDateTime]
            return isoFmt.date(from: startDate)
        }() ?? {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df.date(from: startDate)
        }()
        guard let date else { return startDate }
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        return df.string(from: date)
    }
}

struct FacilityPositionsResponse: Codable {
    let success: Bool
    let count: Int
    let data: [FacilityPosition]
}

struct FacilityPositionResponse: Codable {
    let success: Bool
    let message: String
    let data: FacilityPosition
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

// MARK: - Chat Models

struct ChatMessage: Codable, Identifiable {
    let id: String
    let conversationId: String
    let senderType: String   // "user" or "facility"
    let senderId: String
    let content: String
    let isRead: Bool
    let createdAt: String
    let updatedAt: String
    
    var formattedTime: String {
        let formatter = ISO8601DateFormatter()
        // Try with fractional seconds first, then without
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: createdAt) ?? {
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.date(from: createdAt)
        }()
        guard let date = date else { return "" }
        let display = DateFormatter()
        display.dateFormat = "h:mm a"
        return display.string(from: date)
    }
}

struct ChatConversation: Codable, Identifiable {
    let id: String
    let userId: String
    let facilityId: String
    let user: ChatUser?
    let facility: ChatFacility?
    let messages: [ChatMessage]?
    let createdAt: String
    let updatedAt: String
    
    var lastMessage: ChatMessage? { messages?.last }
}

struct ChatUser: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let profession: String
    
    var fullName: String { "\(firstName) \(lastName)" }
}

struct ChatFacility: Codable {
    let id: String
    let name: String
    let city: String
    let state: String
    let facilityType: String
    
    var location: String { "\(city), \(state)" }
}

struct ConversationsResponse: Codable {
    let success: Bool
    let data: [ChatConversation]
}

struct ConversationResponse: Codable {
    let success: Bool
    let data: ChatConversation
}

struct SendMessageResponse: Codable {
    let success: Bool
    let data: ChatMessage
}

struct StartConversationData: Codable {
    let conversation: ChatConversation
    let message: ChatMessage
}

struct StartConversationResponse: Codable {
    let success: Bool
    let data: StartConversationData
}

// MARK: - AI Job Matching Models

struct AIMatchRequest: Codable {
    let profession: String
    let preferredState: String?
    let minSalary: Double?
    let limit: Int?
}

struct AIMatchedPosition: Codable, Identifiable {
    let id: String
    let facility: Facility
    let title: String
    let profession: String
    let description: String?
    let requirements: String?
    let startDate: String
    let endDate: String?
    let salary: Double
    let hourlyRate: Double?
    let openings: Int
    let status: String
    let matchScore: Int
    let matchReasons: [String]

    var formattedSalary: String {
        if salary >= 1000 {
            return String(format: "$%.0f/yr", salary)
        }
        return String(format: "$%.0f", salary)
    }

    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: startDate) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        return startDate
    }
}

struct AIMatchResponse: Codable {
    let success: Bool
    let profession: String
    let totalScanned: Int
    let matchCount: Int
    let data: [AIMatchedPosition]
}
