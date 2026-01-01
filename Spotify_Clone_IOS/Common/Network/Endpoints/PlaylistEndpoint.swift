//
//  PlaylistEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum PlaylistEndpoint {
    case list
    case my
    case create
    case favorite
    case addFavorite(String)
    case removeFavorite(String)
    case addTrack(String, String)
    case byGenre(String)
    case byUser(Int)
    case bySlug(String)
    case search(String)
    case update(String)
    case deleteTrack(String, String)
    case delete(String)
    
    var path: String {
        switch self {
        case .list:
            return "playlists/"
        case .my, .create:
            return "playlists/my/"
        case .update(let slug):
            return "playlists/my/\(slug)"
        case .favorite:
            return "playlists/favorite/"
        case .addFavorite(let slug), .removeFavorite(let slug):
            return "playlists/\(slug)/favorite/"
        case .addTrack(let slug, let trackSlug):
            return "playlists\(slug)/add/tracks/\(trackSlug)/"
        case .byGenre(let slug):
            return "playlists/?genre__slug=\(slug)"
        case .byUser(let id):
            return "playlists/?user__id=\(id)"
        case .bySlug(let slug):
            return "playlists/\(slug)/"
        case .search(let query):
            return "playlists/?search=\(query)"
        case .delete(let id):
            return "playlists/\(id)/"
        case .deleteTrack(let slug, let trackSlug):
            return "playlists\(slug)/add/tracks/\(trackSlug)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}