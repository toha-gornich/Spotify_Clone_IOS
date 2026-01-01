//
//  UserEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum UserEndpoint {
    case me
    case profileMe
    case byID(String)
    case updateProfile
    case search(String)
    case followers(String)
    case following(String)
    case follow(String)
    case unfollow(String)
    
    var path: String {
        switch self {
        case .me:
            return "auth/users/me/"
        case .profileMe, .updateProfile:
            return "users/profiles/my/"
        case .byID(let id):
            return "users/\(id)/"
        case .search(let query):
            return "users/profiles/?search=\(query)"
        case .followers(let userId):
            return "users/\(userId)/followers/"
        case .following(let userId):
            return "users/\(userId)/following/"
        case .follow(let userId):
            return "users/\(userId)/follow/"
        case .unfollow(let userId):
            return "users/\(userId)/unfollow/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}