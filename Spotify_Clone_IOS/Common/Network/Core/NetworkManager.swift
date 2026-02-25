//
//  NetworkManager.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import SwiftUI


final class NetworkManager {
    
    // MARK: - Singleton
    static let shared = NetworkManager()
    
    // MARK: - Properties
    let cache = NSCache<NSString, UIImage>()
    
    private let session: URLSession
    
    // MARK: - Initialization
    init(session: URLSession = .shared) {
            self.session = session
    }
}
















