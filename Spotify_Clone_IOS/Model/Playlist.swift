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


// MARK: - Playlist Model (Updated)
struct Playlist: Codable, Identifiable {
    let id: Int
    let slug: String
    let title: String
    let image: String
    let color: String
    let trackSlug: String
    let user: User
    let genre: Genre?
    let isPrivate: Bool
    

    enum CodingKeys: String, CodingKey {
        case id, slug, title, image, color, user, genre
        case trackSlug = "track_slug"
        case isPrivate = "is_private"
    }
}
