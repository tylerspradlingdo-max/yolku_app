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
    static let useMockMode = false // ⬅️ Change this to true when testing without a server
    
    // MARK: - Base URL
    
    // Production Heroku URL
    static let productionURL = "https://yolku-9fce1d1d1bb6.herokuapp.com"
    
    // Local development URL
    static let developmentURL = "http://localhost:3000"
    
    // Set to true only when you are actively running the backend locally.
    // Debug builds now use production by default so signup works out of the box.
    #if DEBUG
    static let useLocalDevelopmentServer = false
    static let baseURL = useLocalDevelopmentServer ? developmentURL : productionURL
    #else
    static let baseURL = productionURL
    #endif
    
    // MARK: - API Endpoints
    
    static let apiPath = "/api"
    
    struct Auth {
        static let signIn = "\(baseURL)\(apiPath)/auth/signin"
        static let signUp = "\(baseURL)\(apiPath)/auth/signup"
        static let verify = "\(baseURL)\(apiPath)/auth/verify"
        static let forgotPassword = "\(baseURL)\(apiPath)/auth/forgot-password"
        static let resetPassword = "\(baseURL)\(apiPath)/auth/reset-password"
    }
    
    struct Users {
        static let profile = "\(baseURL)\(apiPath)/users/profile"
        static let deleteAccount = "\(baseURL)\(apiPath)/users/account"
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
    
    struct Messages {
        static let conversations = "\(baseURL)\(apiPath)/messages/conversations"
        static func conversation(id: String) -> String {
            return "\(baseURL)\(apiPath)/messages/conversations/\(id)"
        }
    }
    
    struct AI {
        static let match = "\(baseURL)\(apiPath)/ai/match"
        static let professions = "\(baseURL)\(apiPath)/ai/professions"
    }

    struct Housing {
        static let list = "\(baseURL)\(apiPath)/housing"
    }
    
    struct Facilities {
        static let signUp = "\(baseURL)\(apiPath)/facilities/signup"
        static let signUpFallback = "\(baseURL)\(apiPath)/facility/signup"
        static let signIn = "\(baseURL)\(apiPath)/facilities/signin"
        static let profile = "\(baseURL)\(apiPath)/facilities/profile"
        static let positions = "\(baseURL)\(apiPath)/facilities/positions"
        static let deleteAccount = "\(baseURL)\(apiPath)/facilities/account"
        static func position(id: String) -> String {
            return "\(baseURL)\(apiPath)/facilities/positions/\(id)"
        }
    }
}
