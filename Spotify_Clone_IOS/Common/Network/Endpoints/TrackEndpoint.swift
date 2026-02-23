//
//  TrackEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum TrackEndpoint {
    case tracks
    case liked
    case likeTrack(String)
    case albumsFavorite
    case my
    case createMy
    case bySlug(String)
    case byGenre(String)
    case byArtist(String)
    case byAlbum(String)
    case search(String)
    case like(String)
    case unlike(String)
    
    var path: String {
        switch self {
        case .tracks:
            return "tracks/"
        case .liked:
            return "tracks/liked/"
        case .likeTrack(let slug):
            return "tracks/\(slug)/like/"
        case .albumsFavorite:
            return "albums/favorite/"
        case .my, .createMy:
            return "tracks/my/"
        case .bySlug(let slug):
            return "tracks/\(slug)/"
        case .byGenre(let slug):
            return "tracks/?genre__slug=\(slug)"
        case .byArtist(let slug):
            return "tracks/?artist__slug=\(slug)"
        case .byAlbum(let slug):
            return "tracks/?album__slug=\(slug)"
        case .search(let query):
            return "tracks/?search=\(query)"
        case .like(let id), .unlike(let id):
            return "tracks/\(id)/like/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponentRaw(path)
    }
}
