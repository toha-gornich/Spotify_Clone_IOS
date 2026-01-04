//
//  MyTrackEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum MyTrackEndpoint {
    case list
    case create
    case byID(String)
    case update(String)
    case delete(String)
    
    var path: String {
        switch self {
        case .list, .create:
            return "tracks/my/"
        case .byID(let id), .update(let id), .delete(let id):
            return "tracks/my/\(id)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponentRaw(path)
    }
}
