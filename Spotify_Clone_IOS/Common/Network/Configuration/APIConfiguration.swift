//
//  APIConfiguration.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

struct APIConfiguration {
    static var shared = APIConfiguration()
    
    lazy var environment: AppEnvironment = {
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            return .production
        }
        
        if env == "DEV" {
            return .development
        }
        
        return .production
    }()
}