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
        print("🎵 Starting getTracksBySlugArtist for slug: '\(slug)'")
        
        let fullURL = Constants.API.tracksBySlugArtistURL + "\(slug)"
        print("🔗 Full URL: \(fullURL)")
        
        guard let url = URL(string: fullURL) else {
            print("❌ Invalid URL: \(fullURL)")
            throw APError.invalidURL
        }
        
        print("📡 Making request to: \(url)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("📦 Received data: \(data.count) bytes")
            
            let decoder = JSONDecoder()
            let tracks = try decoder.decode(TracksResponse.self, from: data).results
            
            print("✅ Successfully decoded \(tracks.count) tracks")
            return tracks
            
        } catch {
            print("❌ Error occurred: \(error)")
            throw APError.invalidData
        }
    }
    
    
    func getTracksBySlugAlbum(slug: String) async throws -> [Track] {
        print("getTracksBySlugAlbum")
        
        guard let url = URL(string: Constants.API.tracksBySlugAlbumURL + "\(slug)") else {
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
    
    func getAlbumBySlug(slug: String) async throws -> Album {
        print("getAlbumBySlug")
        guard let url = URL(string: Constants.API.albumsBySlugURL + "\(slug)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(Album.self, from: data)
        } catch{
            throw APError.invalidData
        }
    }

    
    func getAlbumsBySlugArtist(slug: String) async throws -> [Album] {
        print("getAlbumsBySlugArtist")
        guard let url = URL(string: Constants.API.albumsBySlugArtistURL + "\(slug)") else {
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
