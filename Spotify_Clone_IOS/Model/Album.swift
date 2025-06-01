//
//  Album.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation

// MARK: - Album Model
struct Album: Codable, Identifiable {
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
