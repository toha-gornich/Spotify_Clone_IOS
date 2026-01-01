//
//  NetworkManager+Album.swift.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: AlbumServiceProtocol {

    func getAlbumsFavorite() async throws -> [FavoriteAlbumItem] {
        let url = AlbumEndpoint.favorite.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getAlbumsFavorite - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getAlbumsFavorite - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumsFavorite - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(AlbumFavoriteResponse.self, from: data).results
            } catch {
                print("❌ getAlbumsFavorite - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumsFavorite - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getAlbumsFavorite - Network error: \(error)")
            throw error
        }
    }
    
    func postAddFavoriteAlbum(slug: String) async throws {
        let url = AlbumEndpoint.addFavorite(slug).url
        
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
        let url = AlbumEndpoint.removeFavorite(slug).url
        
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
        let url = AlbumEndpoint.list.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getAlbums - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getAlbums - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbums - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(AlbumResponse.self, from: data).results
            } catch {
                print("❌ getAlbums - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbums - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getAlbums - Network error: \(error)")
            throw error
        }
    }

    func getAlbumBySlug(slug: String) async throws -> Album {
        let url = AlbumEndpoint.bySlug(slug).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getAlbumBySlug - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getAlbumBySlug - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumBySlug - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(Album.self, from: data)
            } catch {
                print("❌ getAlbumBySlug - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumBySlug - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getAlbumBySlug - Network error: \(error)")
            throw error
        }
    }

    func getAlbumsBySlugArtist(slug: String) async throws -> [Album] {
        let url = AlbumEndpoint.byArtist(slug).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getAlbumsBySlugArtist - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getAlbumsBySlugArtist - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumsBySlugArtist - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(AlbumResponse.self, from: data).results
            } catch {
                print("❌ getAlbumsBySlugArtist - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumsBySlugArtist - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getAlbumsBySlugArtist - Network error: \(error)")
            throw error
        }
    }
}
