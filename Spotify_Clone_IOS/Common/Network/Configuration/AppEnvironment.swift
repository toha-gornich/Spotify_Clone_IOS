//
//  AppEnvironment.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum AppEnvironment: String {
    case development
    case production
    
    var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "https://placentary-entirely-dulcie.ngrok-free.dev/api/v1/")!
//            return URL(string: "https://placentary-entirely-dulcie.ngrok-free.dev/api/v1/")!
        case .production:
            return URL(string: "https://spotify-api-production-6731.up.railway.app/")!
//            return URL(string: "http://192.168.0.108:8080/api/v1/")!
        }
    }
}
