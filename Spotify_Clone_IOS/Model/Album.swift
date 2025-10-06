//
//  Album.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation

// MARK: - Album Model
struct AlbumTrack: Codable, Identifiable {
    let id: Int
    let slug: String
    let title: String
    let image: String
    let color: String
    let isPrivate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, slug, title, image, color
        case isPrivate = "is_private"
    }
    
    static func empty() -> AlbumTrack {
            return AlbumTrack(
                id: 0,
                slug: "",
                title: "",
                image: "",
                color: "#000000",
                isPrivate: false
            )
        }
}


// MARK: - Main Album Response Model
struct AlbumResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Album]
}

struct AlbumMyResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [AlbumMy]
}


// MARK: - Album Model
struct AlbumMy: Codable, Identifiable {
    let id: Int
    let slug: String
    let title: String
    let description: String
    let artist: ArtistTracksMy
    let albumListeners: Int
    let image: String?
    let color: String?
    let tracks: [Track]
    let duration: String
    let isPrivate: Bool
    let releaseDate: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, slug, title, description, artist, image, color, tracks, duration
        case albumListeners = "album_listeners"
        case isPrivate = "is_private"
        case releaseDate = "release_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct Album: Codable, Identifiable {
    let id: Int
    let slug: String
    let title: String
    let description: String
    let artist: ArtistAlbum
    let trackSlug: String?
    let image: String
    let color: String
    let isPrivate: Bool
    let releaseDate: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, slug, title, description, artist, image, color
        case trackSlug = "track_slug"
        case isPrivate = "is_private"
        case releaseDate = "release_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    static let empty = Album(
        id: 0,
        slug: "",
        title: "",
        description: "",
        artist: ArtistAlbum.empty,
        trackSlug: nil,
        image: "",
        color: "",
        isPrivate: false,
        releaseDate: "",
        createdAt: "",
        updatedAt: ""
    )
}
