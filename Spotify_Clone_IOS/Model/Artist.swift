//
//  Artist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation



// MARK: - Album Artist Model (simplified artist info for albums)
struct ArtistAlbum: Codable, Identifiable {
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
    static var empty: ArtistAlbum {
           ArtistAlbum(
               id: -1,
               slug: "",
               displayName: "",
               image: "",
               color: "#000000",
               isVerify: false
           )
       }
}

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
    let results: [Artist]
}

struct ArtistFavoriteResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [FavoriteArtistItem]
}




// MARK: - Artist Model


struct FavoriteArtistItem: Codable {
    let id: Int
    let artist: ArtistTrack
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case artist
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
        func toArtist() -> ArtistTrack {
            return ArtistTrack(
                id: artist.id,
                slug: artist.slug,
                displayName: artist.displayName,
                image: artist.image,
                color: artist.color,
                isVerify: artist.isVerify
            )
        }
        
        
        static func toArtists(_ items: [FavoriteArtistItem]) -> [ArtistTrack] {
            return items.map { $0.toArtist() }
        }
}

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
    static var empty: Artist {
        Artist(
            id: -1,
            slug: "",
            user: User.empty,
            firstName: "",
            lastName: "",
            displayName: "",
            image: "",
            color: "#000000",
            trackSlug: "",
            artistListeners: 0,
            isVerify: false
        )
    }
}

struct ArtistTracksMy: Codable, Identifiable {
    let id: Int
    let slug: String
    let displayName: String
    let image: String
    let color: String
    let isVerify: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case displayName = "display_name"
        case image
        case color
        case isVerify = "is_verify"
    }
    static func empty() -> ArtistTracksMy {
        return ArtistTracksMy(
            id: 0,
            slug: "",
            displayName: "",
            image: "",
            color: "#000000",
            isVerify: false
        )
    }
}
    
struct UpdateArtist: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let displayName: String
    let image: String

    
    enum CodingKeys: String, CodingKey {
        case id, image
        case firstName = "first_name"
        case lastName = "last_name"
        case displayName = "display_name"
    }
}
    
    
    
    // MARK: - Extension for convenience methods
    extension Artist {
        var fullName: String {
            return "\(firstName) \(lastName)"
        }
        
        var formattedListeners: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: artistListeners)) ?? "0"
        }
        
        var hasTrack: Bool {
            return trackSlug != nil
        }
    }
    
   extension User {
        var isArtist: Bool {
            return typeProfile == "Artist"
        }
    }
    
    // MARK: - Sample Usage
    class ArtistService {
        func parseArtistResponse(from data: Data) -> ArtistResponse? {
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ArtistResponse.self, from: data)
                return response
            } catch {
                print("Error parsing artist response: \(error)")
                return nil
            }
        }
        
        func encodeArtistResponse(_ response: ArtistResponse) -> Data? {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                return try encoder.encode(response)
            } catch {
                print("Error encoding artist response: \(error)")
                return nil
            }
        }
    }
