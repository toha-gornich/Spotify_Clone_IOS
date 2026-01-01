//
//  ArtistEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum ArtistEndpoint {
    case list
    case favorite
    case me
    case licenses
    case search(String)
    case bySlug(String)
    case addFavorite(String)
    case removeFavorite(String)
    
    var path: String {
        switch self {
        case .list:
            return "artists/"
        case .favorite:
            return "artists/favorite/"
        case .me:
            return "artists/me/"
        case .licenses:
            return "artists/me/license/"
        case .search(let query):
            return "artists/?search=\(query)"
        case .bySlug(let slug):
            return "artists/\(slug)/"
        case .addFavorite(let slug), .removeFavorite(let slug):
            return "artists/\(slug)/favorite/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}