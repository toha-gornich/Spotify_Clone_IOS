//
//  AuthEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum AuthEndpoint {
    case createToken
    case verifyToken
    case activationEmail
    case registerUser
    case userMe
    case profilesMy
    case user
    
    var path: String {
        switch self {
        case .createToken:
            return "auth/jwt/create/"
        case .verifyToken:
            return "auth/jwt/verify/"
        case .activationEmail:
            return "auth/users/activation/"
        case .registerUser:
            return "auth/users/"
        case .userMe:
            return "auth/users/me/"
        case .profilesMy:
            return "users/profiles/my/"
        case .user:
            return "users/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponentRaw(path)
    }
}
