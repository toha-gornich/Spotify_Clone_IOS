//
//  Genre.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation


// MARK: - Genre Model
struct Genre: Codable, Identifiable {
    let id: Int
    let slug: String
    let name: String
    let image: String
    let color: String
}


// MARK: - Main Response
struct GenresResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Genre]
}


