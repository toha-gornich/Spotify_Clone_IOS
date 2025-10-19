//
//  NetworkManager+Playlist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation
extension NetworkManager: PlaylistServiceProtocol {
    func getPlaylists() async throws ->[Playlist] {
        guard let url = URL(string: Constants.API.playlistsURL) else {
            print("❌ [getPlaylists] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylists] Response error: \(httpResponse.statusCode)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            print("❌ [getPlaylists] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsByIdUser(idUser: Int) async throws -> [Playlist] {
        guard let url = URL(string: Constants.API.playlistsByIdUserURL + "\(idUser)") else {
            print("❌ [getPlaylistsByIdUser] Invalid URL for user ID: \(idUser)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylistsByIdUser] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            let playlists = try decoder.decode(PlaylistResponse.self, from: data).results
            return playlists
        } catch {
            print("❌ [getPlaylistsByIdUser] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsBySlug(slug:String) async throws -> PlaylistDetail {
        guard let url = URL(string: Constants.API.playlistBySlugURL + "\(slug)/") else {
            print("❌ [getPlaylistsBySlug] Invalid URL for slug: \(slug)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylistsBySlug] Response error: \(httpResponse.statusCode) for slug: \(slug)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistDetail.self, from: data)
        } catch{
            print("❌ [getPlaylistsBySlug] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }

    func getPlaylistsBySlugGenre(slug:String) async throws ->[Playlist] {
        guard let url = URL(string: Constants.API.playlistsByGenreURL + slug) else {
            print("❌ [getPlaylistsBySlugGenre] Invalid URL for genre slug: \(slug)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylistsBySlugGenre] Response error: \(httpResponse.statusCode) for genre: \(slug)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            print("❌ [getPlaylistsBySlugGenre] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsFavorite() async throws -> [FavoritePlaylistItem] {
        guard let url = URL(string: Constants.API.playlistsFavoriteURL) else {
            print("❌ [getPlaylistsFavorite] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylistsFavorite] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistFavoriteResponse.self, from: data).results
        } catch {
            print("❌ [getPlaylistsFavorite] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getPlaylistsFavorite] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }
    
    func postAddFavoritePlaylist(slug: String) async throws {
        let urlString = Constants.API.playlistsURL + "\(slug)/favorite/"
        
        guard let url = URL(string: urlString) else {
            print("❌ postAddFavoritePlaylist - Invalid URL: \(urlString)")
            throw FavoriteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postAddFavoritePlaylist - Invalid response type")
                throw FavoriteError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                print("✅ postAddFavoritePlaylist - Successfully added: \(slug)")
                return
                
            case 400, 409:
                print("ℹ️ postAddFavoritePlaylist - Already in favorites: \(slug)")
                throw FavoriteError.alreadyLiked
                
            default:
                print("❌ postAddFavoritePlaylist - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postAddFavoritePlaylist - Response: \(responseString)")
                }
                throw FavoriteError.invalidResponse
            }
            
        } catch let error as FavoriteError {
            throw error
        } catch {
            print("❌ postAddFavoritePlaylist - Network error: \(error)")
            throw error
        }
    }
    
    func deletePlaylistFavorite(slug: String) async throws {
        guard let url = URL(string: Constants.API.playlistsURL + "\(slug)/favorite/") else {
            print("❌ deletePlaylistFavorite - Invalid URL: \(Constants.API.playlistsURL + "\(slug)/favorite/")")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deletePlaylistFavorite - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deletePlaylistFavorite - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deletePlaylistFavorite - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deletePlaylistFavorite - Network error: \(error)")
            throw error
        }
    }
}
