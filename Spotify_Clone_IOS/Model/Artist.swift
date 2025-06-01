//
//  Artist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation


// MARK: - Artist Model
struct ArtistTrack: Codable, Identifiable {
    let id: Int
    let slug: String
    let displayName: String
    let image: String
    let color: String
    let isVerify: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, slug, image, color
        case displayName = "display_name"
        case isVerify = "is_verify"
    }
}

// MARK: - Main Response Model
struct ArtistResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ArtistTrack]
}


// MARK: - Artist Model
struct Artist: Codable, Identifiable {
    let id: Int
    let slug: String
    let user: User
    let firstName: String
    let lastName: String
    let displayName: String
    let image: String
    let color: String
    let trackSlug: String?
    let artistListeners: Int
    let isVerify: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, slug, user, image, color
        case firstName = "first_name"
        case lastName = "last_name"
        case displayName = "display_name"
        case trackSlug = "track_slug"
        case artistListeners = "artist_listeners"
        case isVerify = "is_verify"
    }
}
