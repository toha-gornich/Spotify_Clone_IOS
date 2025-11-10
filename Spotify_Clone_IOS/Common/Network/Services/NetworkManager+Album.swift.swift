//
//  NetworkManager+Album.swift.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: AlbumServiceProtocol {

    func getAlbumsFavorite() async throws -> [FavoriteAlbumItem] {
        guard let url = URL(string: Constants.API.albumsFavoriteURL) else {
            print("❌ [getAlbumsFavorite] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbumsFavorite] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumFavoriteResponse.self, from: data).results
        } catch {
            print("❌ [getAlbumsFavorite] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbumsFavorite] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }
    
    func postAddFavoriteAlbum(slug: String) async throws {
        let urlString = Constants.API.albumsURL + "\(slug)/favorite/"
        
        guard let url = URL(string: urlString) else {
            print("❌ postAddFavoriteAlbum - Invalid URL: \(urlString)")
            throw FavoriteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postAddFavoriteAlbum - Invalid response type")
                throw FavoriteError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                
                return
                
            case 400, 409:
                print("ℹ️ postAddFavoriteAlbum - Already in favorites: \(slug)")
                throw FavoriteError.alreadyLiked
                
            default:
                print("❌ postAddFavoriteAlbum - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postAddFavoriteAlbum - Response: \(responseString)")
                }
                throw FavoriteError.invalidResponse
            }
            
        } catch let error as FavoriteError {
            throw error
        } catch {
            print("❌ postAddFavoriteAlbum - Network error: \(error)")
            throw error
        }
    }
    
    func deleteAlbumsFavorite(slug: String) async throws {
        guard let url = URL(string: Constants.API.albumsURL + "\(slug)/favorite/") else {
            print("❌ deleteAlbumsFavorite - Invalid URL: \(Constants.API.albumsURL + "\(slug)/favorite/")")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteAlbumsFavorite - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteAlbumsFavorite - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteAlbumsFavorite - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteAlbumsFavorite - Network error: \(error)")
            throw error
        }
    }
    
    func getAlbums() async throws -> [Album] {
        print("getAlbums")
        guard let url = URL(string: Constants.API.albumsURL) else {
            print("❌ [getAlbums] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbums] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch {
            print("❌ [getAlbums] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbums] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }

    func getAlbumBySlug(slug: String) async throws -> Album {
        print("getAlbumBySlug")
        guard let url = URL(string: Constants.API.albumsBySlugURL + "\(slug)") else {
            print("❌ [getAlbumBySlug] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbumBySlug] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Album.self, from: data)
        } catch {
            print("❌ [getAlbumBySlug] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbumBySlug] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }

    func getAlbumsBySlugArtist(slug: String) async throws -> [Album] {
        print("getAlbumsBySlugArtist")
        guard let url = URL(string: Constants.API.albumsBySlugArtistURL + "\(slug)") else {
            print("❌ [getAlbumsBySlugArtist] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbumsBySlugArtist] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch {
            print("❌ [getAlbumsBySlugArtist] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbumsBySlugArtist] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }
    
}
