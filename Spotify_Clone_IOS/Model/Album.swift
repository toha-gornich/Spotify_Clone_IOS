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
    let duration: String?
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
    
    var formattedListenersCount: String {
        formatNumber(albumListeners)
    }
    
    
    var formattedReleaseDate: String {
        guard let releaseDate = releaseDate, !releaseDate.isEmpty else {
            return "Unknown"
        }
        
        let dateFormatter = DateFormatter()
        
        //full date format first (YYYY-MM-DD)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: releaseDate) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        // year-month format (YYYY-MM)
        dateFormatter.dateFormat = "yyyy-MM"
        if let date = dateFormatter.date(from: releaseDate) {
            dateFormatter.dateFormat = "MMM yyyy"
            return dateFormatter.string(from: date)
        }
        
        // year only format (YYYY)
        dateFormatter.dateFormat = "yyyy"
        if let date = dateFormatter.date(from: releaseDate) {
            return releaseDate
        }
        
        
        return releaseDate
    }
    
    /// Short release date (e.g., "2024")
    var shortReleaseDate: String {
        guard let releaseDate = releaseDate, !releaseDate.isEmpty else {
            return "—"
        }
        
        
        if releaseDate.count >= 4 {
            return String(releaseDate.prefix(4))
        }
        
        return releaseDate
    }
    
    /// Number of tracks in album
    var tracksCount: Int {
        tracks.count
    }
    
    /// Format number with K, M, B suffixes
    private func formatNumber(_ number: Int) -> String {
        let thousand = 1_000
        let million = 1_000_000
        let billion = 1_000_000_000
        
        switch number {
        case billion...:
            let value = Double(number) / Double(billion)
            return String(format: "%.1fB", value)
        case million...:
            let value = Double(number) / Double(million)
            return String(format: "%.1fM", value)
        case thousand...:
            let value = Double(number) / Double(thousand)
            return String(format: "%.1fK", value)
        default:
            return "\(number)"
        }
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
