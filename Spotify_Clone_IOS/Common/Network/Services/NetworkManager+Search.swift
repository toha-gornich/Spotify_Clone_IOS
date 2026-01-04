//
//  NetworkManager+Search.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: SearchServiceProtocol {
    func searchTracks(searchText: String) async throws -> [Track] {
        print("searchTracks")
        let url = SearchEndpoint.tracks(searchText).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchTracks - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchTracks - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchTracks - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksResponse.self, from: data).results
            } catch {
                print("❌ searchTracks - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchTracks - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ searchTracks - Network error: \(error)")
            throw error
        }
    }
    
    func searchArtists(searchText: String) async throws -> [Artist] {
        let url = SearchEndpoint.artists(searchText).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchArtists - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchArtists - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchArtists - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(ArtistResponse.self, from: data).results
            } catch {
                print("❌ searchArtists - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchArtists - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ searchArtists - Network error: \(error)")
            throw error
        }
    }
    
    func searchAlbums(searchText: String) async throws -> [Album] {
        let url = SearchEndpoint.albums(searchText).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchAlbums - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchAlbums - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchAlbums - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(AlbumResponse.self, from: data).results
            } catch {
                print("❌ searchAlbums - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchAlbums - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ searchAlbums - Network error: \(error)")
            throw error
        }
    }
    
    func searchPlaylists(searchText: String) async throws -> [Playlist] {
        let url = SearchEndpoint.playlists(searchText).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchPlaylists - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchPlaylists - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchPlaylists - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(PlaylistResponse.self, from: data).results
            } catch {
                print("❌ searchPlaylists - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchPlaylists - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ searchPlaylists - Network error: \(error)")
            throw error
        }
    }
    
    func searchProfiles(searchText: String) async throws -> [User] {
        let url = SearchEndpoint.profiles(searchText).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchProfiles - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchProfiles - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchProfiles - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(UserResponse.self, from: data).results
            } catch {
                print("❌ searchProfiles - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ searchProfiles - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ searchProfiles - Network error: \(error)")
            throw error
        }
    }
}
