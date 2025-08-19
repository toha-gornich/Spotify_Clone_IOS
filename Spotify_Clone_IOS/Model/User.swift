//
//  User.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation


// MARK: - User Model
struct User: Codable, Identifiable {
    let id: Int
    let displayName: String
    let typeProfile: String
    let artistSlug: String?
    let image: String
    let followersCount: Int
    let isPremium: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, image
        case displayName = "display_name"
        case typeProfile = "type_profile"
        case artistSlug = "artist_slug"
        case followersCount = "followers_count"
        case isPremium = "is_premium"
    }
    static var empty: User {
            User(
                id: -1,
                displayName: "",
                typeProfile: "",
                artistSlug: "",
                image: "",
                followersCount: 0,
                isPremium: false
            )
        }
}

// MARK: - Main Response
struct UserResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [User]
}


struct LoginRequest: Codable {
    let email: String
    let password: String
    
    static var empty: LoginRequest {
        LoginRequest(
            email: "",
            password: ""
        )
    }
}

struct LoginResponse: Codable {
    let access: String
    let refresh: String
    
    static var empty: LoginResponse {
        LoginResponse(
            access: "",
            refresh: ""
        )
    }
}

struct TokenVerifyRequest: Codable {
    let token: String
}

struct RegUser: Codable {
    let email: String
    let displayName: String
    let password: String
    let rePassword: String
    
    enum CodingKeys: String, CodingKey {
        case email, password
        case displayName = "display_name"
        case rePassword = "re_password"
    }
    
    static var empty: RegUser {
        RegUser(
            email: "",
            displayName: "",
            password: "",
            rePassword: ""
        )
    }
}

struct RegUserResponse: Codable {
    let email: String
    let displayName: String
    let gender: String
    let country: String
    let typeProfile: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case email, gender, country, image
        case displayName = "display_name"
        case typeProfile = "type_profile"
    }
    
    static var empty: RegUserResponse {
        RegUserResponse(
            email: "",
            displayName: "",
            gender: "",
            country: "",
            typeProfile: "user",
            image: ""
        )
    }
}

