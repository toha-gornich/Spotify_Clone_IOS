//
//  SearchEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum SearchEndpoint {
    case tracks(String, page: Int)
    case artists(String, page: Int)
    case albums(String, page: Int)
    case playlists(String, page: Int)
    case profiles(String, page: Int)
    case all(String, page: Int)
    
    var path: String {
        switch self {
        case .tracks(let query, let page):
            return "tracks/?search=\(query)&page=\(page)"
        case .artists(let query, let page):
            return "artists/?search=\(query)&page=\(page)"
        case .albums(let query, let page):
            return "albums/?search=\(query)&page=\(page)"
        case .playlists(let query, let page):
            return "playlists/?search=\(query)&page=\(page)"
        case .profiles(let query, let page):
            return "users/profiles/?search=\(query)&page=\(page)"
        case .all(let query, let page):
            return "search/?q=\(query)&page=\(page)"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponentRaw(path)
    }
}
