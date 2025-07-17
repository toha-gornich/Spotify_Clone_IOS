//
//  Tracks.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import Foundation

// MARK: - Main Response
struct TracksResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Track]
}

// MARK: - Track Model
struct Track: Codable, Identifiable {
    let id: Int
    let slug: String
    let artist: ArtistTrack
    let title: String
    let file: String
    let duration: String
    let image: String
    let color: String
    let playsCount: Int
    let genre: Genre
    let album: AlbumTrack
    
    enum CodingKeys: String, CodingKey {
        case id, slug, artist, title, file, duration, image, color, genre, album
        case playsCount = "plays_count"
    }
}

struct TrackDetail: Codable, Identifiable {
    let id: Int
    let slug: String
    let artist: ArtistTrack
    let title: String
    let file: String
    let duration: String
    let image: String
    let color: String
    let playsCount: Int
    let genre: Genre
    let album: AlbumTrack
    let createdAt: String?
    let updatedAt: String?
    let isLiked: Bool?
    let lyrics: String?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, artist, title, file, duration, image, color, genre, album, lyrics
        case playsCount = "plays_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isLiked = "is_liked"
    }
}

// MARK: - Extension for convenience
extension Track {
    // Converting duration from time to seconds
    var durationInSeconds: TimeInterval {
        let components = duration.components(separatedBy: ":")
        guard components.count >= 3,
              let hours = Double(components[0]),
              let minutes = Double(components[1]),
              let seconds = Double(components[2].components(separatedBy: ".")[0]) else {
            return 0
        }
        return hours * 3600 + minutes * 60 + seconds
    }
    
    // Formatted duration for display
    var formattedDuration: String {
        let totalSeconds = Int(durationInSeconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // Formatted number of listens
    var formattedPlaysCount: String {
        if playsCount >= 1_000_000_000 {
            return String(format: "%.1fB", Double(playsCount) / 1_000_000_000)
        } else if playsCount >= 1_000_000 {
            return String(format: "%.1fM", Double(playsCount) / 1_000_000)
        } else if playsCount >= 1_000 {
            return String(format: "%.1fK", Double(playsCount) / 1_000)
        } else {
            return "\(playsCount)"
        }
    }
}

extension TrackDetail {
    // Converting duration from time to seconds
    var durationInSeconds: TimeInterval {
        let components = duration.components(separatedBy: ":")
        guard components.count >= 3,
              let hours = Double(components[0]),
              let minutes = Double(components[1]),
              let seconds = Double(components[2].components(separatedBy: ".")[0]) else {
            return 0
        }
        return hours * 3600 + minutes * 60 + seconds
    }
    
    // Formatted duration for display
    var formattedDuration: String {
        let totalSeconds = Int(durationInSeconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // Formatted number of plays
    var formattedPlaysCount: String {
        if playsCount >= 1_000_000_000 {
            return String(format: "%.1fB", Double(playsCount) / 1_000_000_000)
        } else if playsCount >= 1_000_000 {
            return String(format: "%.1fM", Double(playsCount) / 1_000_000)
        } else if playsCount >= 1_000 {
            return String(format: "%.1fK", Double(playsCount) / 1_000)
        } else {
            return "\(playsCount)"
        }
    }
    
    // Formatted created date
    var formattedCreatedDate: String {
        guard let createdAt = createdAt else { return "Unknown" }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: createdAt) else {
            return "Unknown"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
        
        return outputFormatter.string(from: date)
    }
    
    // Check if track has lyrics
    var hasLyrics: Bool {
        return lyrics != nil && !lyrics!.isEmpty
    }
    
    // Get artist name
    var artistName: String {
        return artist.displayName
    }
    
    // Get album title
    var albumTitle: String {
        return album.title
    }
    
    // Get genre name
    var genreName: String {
        return genre.name
    }
}


struct MockData{
    static let track = Track(
        id: 52,
        slug: "i-was-never-there",
        artist: ArtistTrack(
            id: 2,
            slug: "artist2",
            displayName: "The Weeknd",
            image: "http://192.168.0.110:8080/mediafiles/artists/artist2/ab6761610000e5eb214f3cf1cbe7139c1e26ffbb.jpg",
            color: "#292f3a",
            isVerify: true
        ),
        title: "I Was Never There",
        file: "http://192.168.0.110:8080/mediafiles/artists/artist11/tracks/i-was-never-there/The_Weeknd_Gesaffelstein__I_Was_Never_There.mp3",
        duration: "00:04:01.136327",
        image: "http://192.168.0.110:8080/mediafiles/default/track.jpg",
        color: "#333333",
        playsCount: 164364578,
        genre: Genre(
            id: 16,
            slug: "punk",
            name: "Punk",
            image: "http://192.168.0.110:8080/mediafiles/genres/punk/ab67616d0000b273f8d415dab5ed7e3747bd38dd.jpg",
            color: "#8c3a4a"
        ),
        album: AlbumTrack(
            id: 16,
            slug: "my-dear",
            title: "My Dear",
            image: "http://192.168.0.110:8080/mediafiles/albums/my-dear/818RSApG0PL._UF8941000_QL80_.jpg",
            color: "#1e140f",
            isPrivate: false
        )
    )
    
    static let trackDetail = TrackDetail(
            id: 52,
            slug: "i-was-never-there",
            artist: ArtistTrack(
                id: 2,
                slug: "artist2",
                displayName: "The Weeknd",
                image: "http://192.168.0.110:8080/mediafiles/artists/artist2/ab6761610000e5eb214f3cf1cbe7139c1e26ffbb.jpg",
                color: "#292f3a",
                isVerify: true
            ),
            title: "I Was Never There",
            file: "http://192.168.0.110:8080/mediafiles/artists/artist11/tracks/i-was-never-there/The_Weeknd_Gesaffelstein__I_Was_Never_There.mp3",
            duration: "00:04:01.136327",
            image: "http://192.168.0.110:8080/mediafiles/default/track.jpg",
            color: "#333333",
            playsCount: 164364578,
            genre: Genre(
                id: 16,
                slug: "punk",
                name: "Punk",
                image: "http://192.168.0.110:8080/mediafiles/genres/punk/ab67616d0000b273f8d415dab5ed7e3747bd38dd.jpg",
                color: "#8c3a4a"
            ),
            album: AlbumTrack(
                id: 16,
                slug: "my-dear",
                title: "My Dear",
                image: "http://192.168.0.110:8080/mediafiles/albums/my-dear/818RSApG0PL._UF8941000_QL80_.jpg",
                color: "#1e140f",
                isPrivate: false
            ),
            createdAt: "2024-01-15T10:30:00Z",
            updatedAt: "2024-01-15T10:30:00Z",
            isLiked: false,
            lyrics: "Sample lyrics for the track..."
        )
}

