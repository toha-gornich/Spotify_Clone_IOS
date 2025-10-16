//
//  APError.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import Foundation


enum APError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
}

enum FavoriteError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case alreadyLiked 
}
