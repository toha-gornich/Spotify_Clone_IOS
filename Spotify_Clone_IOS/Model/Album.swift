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
}


// MARK: - Main Album Response Model
struct AlbumResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Album]
}



// MARK: - Album Model
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
}
