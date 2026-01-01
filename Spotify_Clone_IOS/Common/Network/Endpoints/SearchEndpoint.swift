//
//  SearchEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum SearchEndpoint {
    case tracks(String)
    case artists(String)
    case albums(String)
    case playlists(String)
    case profiles(String)
    case all(String)
    
    var path: String {
        switch self {
        case .tracks(let query):
            return "tracks/?search=\(query)"
        case .artists(let query):
            return "artists/?search=\(query)"
        case .albums(let query):
            return "albums/?search=\(query)"
        case .playlists(let query):
            return "playlists/?search=\(query)"
        case .profiles(let query):
            return "users/profiles/?search=\(query)"
        case .all(let query):
            return "search/?q=\(query)"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}