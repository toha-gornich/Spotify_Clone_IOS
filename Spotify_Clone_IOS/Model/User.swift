//
//  User.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation


// MARK: - User Model
struct User: Codable, Identifiable {
    let id: Int
    let displayName: String
    let typeProfile: String
    let artistSlug: String
    let image: String
    let followersCount: Int
    let isPremium: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, image
        case displayName = "display_name"
        case typeProfile = "type_profile"
        case artistSlug = "artist_slug"
        case followersCount = "followers_count"
        case isPremium = "is_premium"
    }
}
