//
//  Playlist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 05.06.2025.
//

import Foundation



// MARK: - Main Response Model
struct PlaylistResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Playlist]
}


struct PlaylistFavoriteResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [FavoritePlaylistItem]
}

// MARK: - Playlist Model (Updated)

struct FavoritePlaylistItem: Codable {
    let id: Int
    let playlist: Playlist
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case playlist
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
    func toPlaylist() -> Playlist {
        return playlist
    }
    
    
    static func toPlaylists(_ items: [FavoritePlaylistItem]) -> [Playlist] {
        return items.map { $0.toPlaylist() }
    }
}


struct Playlist: Codable, Identifiable {
   let id: Int
   let slug: String
   let title: String
   let image: String
   let color: String
   let trackSlug: String?
   let user: User
   let genre: Genre?
   let isPrivate: Bool
   
   enum CodingKeys: String, CodingKey {
       case id, slug, title, image, color, user, genre
       case trackSlug = "track_slug"
       case isPrivate = "is_private"
   }
   
   static var empty: Playlist {
       return Playlist(
           id: 0,
           slug: "",
           title: "",
           image: "",
           color: "",
           trackSlug: "",
           user: User.empty,
           genre: nil,
           isPrivate: false
       )
   }
}


// MARK: - PlaylistDetail Model (for single playlist by slug)
struct PlaylistDetail: Codable, Identifiable {
    let id: Int
    let slug: String
    let title: String
    let description: String?
    let image: String
    let color: String
    let user: User
    let tracks: [Track]?
    let genre: Genre?
    let releaseDate: String?
    let isPrivate: Bool?
    let duration: String?
    let favoriteCount: Int?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, title, description, image, color, user, tracks, genre, duration
        case releaseDate = "release_date"
        case isPrivate = "is_private"
        case favoriteCount = "favorite_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    static var empty: PlaylistDetail {
        return PlaylistDetail(
            id: 0,
            slug: "",
            title: "",
            description: "",
            image: "",
            color: "",
            user: User.empty,
            tracks: [],
            genre: nil,
            releaseDate: "",
            isPrivate: false,
            duration: "",
            favoriteCount: 0,
            createdAt: "",
            updatedAt: ""
        )
    }
}

struct PatchPlaylistResponse: Codable, Identifiable {
    let id: Int
    let slug: String
    let title: String
    let description: String?
    let image: String?
    let genre: Genre?
    let releaseDate: String
    let isPrivate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, slug, title, description, image, genre
        case releaseDate = "release_date"
        case isPrivate = "is_private"
    }
}
