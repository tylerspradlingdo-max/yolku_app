//
//  APIConfig.swift
//  YolkuApp
//
//  API Configuration for Yolku Backend
//

import Foundation

struct APIConfig {
    // MARK: - Testing Mode
    
    // Set to true to use mock data (no server required)
    // Set to false to connect to real API
    static let useMockMode = true // ⬅️ Change this to false when you have server connection
    
    // MARK: - Base URL
    
    // Production Heroku URL
    static let productionURL = "https://yolku-9fce1d1d1bb6.herokuapp.com"
    
    // Local development URL
    static let developmentURL = "http://localhost:3000"
    
    // Current environment - change this to switch between prod and dev
    #if DEBUG
    static let baseURL = developmentURL
    #else
    static let baseURL = productionURL
    #endif
    
    // MARK: - API Endpoints
    
    static let apiPath = "/api"
    
    struct Auth {
        static let signIn = "\(baseURL)\(apiPath)/auth/signin"
        static let signUp = "\(baseURL)\(apiPath)/auth/signup"
        static let verify = "\(baseURL)\(apiPath)/auth/verify"
    }
    
    struct Users {
        static let profile = "\(baseURL)\(apiPath)/users/profile"
    }
    
    struct Health {
        static let check = "\(baseURL)\(apiPath)/health"
    }
    
    struct Positions {
        static let list = "\(baseURL)\(apiPath)/positions"
        static let states = "\(baseURL)\(apiPath)/positions/states/list"
        static func detail(id: String) -> String {
            return "\(baseURL)\(apiPath)/positions/\(id)"
        }
    }
}
