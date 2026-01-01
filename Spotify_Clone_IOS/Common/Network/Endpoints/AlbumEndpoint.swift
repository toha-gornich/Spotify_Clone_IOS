//
//  AlbumEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum AlbumEndpoint {
    case list
    case favorite
    case my
    case bySlug(String)
    case byArtist(String)
    case search(String)
    case addFavorite(String)
    case removeFavorite(String)
    
    var path: String {
        switch self {
        case .list:
            return "albums/"
        case .favorite:
            return "albums/favorite/"
        case .my:
            return "albums/my/"
        case .bySlug(let slug):
            return "albums/\(slug)/"
        case .byArtist(let slug):
            return "albums/?album__slug=\(slug)"
        case .search(let query):
            return "albums/?search=\(query)"
        case .addFavorite(let slug), .removeFavorite(let slug):
            return "albums/\(slug)/favorite/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}