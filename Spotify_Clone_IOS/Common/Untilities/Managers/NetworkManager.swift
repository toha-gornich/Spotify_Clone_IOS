//
//  NetworkManager.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import SwiftUI



final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
        
    private init() {}
  
    
    func getTracks() async throws ->[Track] {
        guard let url = URL(string: Constants.API.tracksURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(TracksResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
        
        
    }
    
    func getTracksBySlugArtist(slug: String) async throws -> [Track] {
        print(Constants.API.tracksBySlugArtistURL + "\(slug)")
        guard let url = URL(string: Constants.API.tracksBySlugArtistURL + "\(slug)/") else {
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Виводимо HTTP статус
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        
        // Виводимо сирий JSON
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON Response:")
            print(jsonString)
        } else {
            print("Unable to decode response data to string")
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(TracksResponse.self, from: data)
            print("Decoded successfully. Number of tracks: \(result.results.count)")
            return result.results
        } catch {
            print("Decoding error: \(error)")
            if let decodingError = error as? DecodingError {
                print("Decoding error details: \(decodingError)")
            }
            throw APError.invalidData
        }
    }

    
    func getArtistsBySlug(slug:String) async throws -> Artist {
        guard let url = URL(string: Constants.API.artistsURL + "\(slug)/") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(Artist.self, from: data)
        } catch{
            throw APError.invalidData
        }
        
        
    }
    
    func getArtists() async throws ->[Artist] {
        guard let url = URL(string: Constants.API.artistsURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(ArtistResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
        
        
    }
    
    
    func getAlbums() async throws ->[Album] {
        guard let url = URL(string: Constants.API.albumsURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
        
        
    }

    func getPlaylists() async throws ->[Playlist] {
        guard let url = URL(string: Constants.API.playlistsURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            
            throw APError.invalidData
        }
        
        
    }
    
    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void){
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, response, error in
            
            guard let data, let image = UIImage(data:data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()

    }
    
}
