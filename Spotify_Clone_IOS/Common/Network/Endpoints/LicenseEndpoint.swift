//
//  LicenseEndpoint.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.01.2026.
//


import Foundation

enum LicenseEndpoint {
    case list
    case myLicenses
    case byID(String)
    case getById(String)
    case deleteById(String)
    
    var path: String {
        switch self {
        case .list:
            return "licenses/"
        case .myLicenses:
            return "artists/me/license/"
        case .byID(let id):
            return "licenses/\(id)/"
        case .getById(let id), .deleteById(let id):
            return "artists/me/license/\(id)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}