//
//  GenreEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum GenreEndpoint {
    case list
    case bySlug(String)
    
    var path: String {
        switch self {
        case .list:
            return "others/genres/"
        case .bySlug(let slug):
            return "others/genres/\(slug)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}