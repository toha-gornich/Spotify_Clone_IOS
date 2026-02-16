//
//  NetworkManager+Search.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: SearchServiceProtocol {
    func searchTracks(searchText: String, page: Int = 1) async throws -> TracksResponse {
        print("searchTracks - page: \(page)")
        let url = SearchEndpoint.tracks(searchText, page: page).url
        
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
                let tracksResponse = try decoder.decode(TracksResponse.self, from: data)
                print("✅ searchTracks - Success: \(tracksResponse.results.count) tracks, page: \(page), next: \(tracksResponse.next ?? "nil")")
                return tracksResponse
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
    
    func searchArtists(searchText: String, page: Int = 1) async throws -> ArtistResponse {
        print("searchArtists - page: \(page)")
        let url = SearchEndpoint.artists(searchText, page: page).url
        
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
                let artistResponse = try decoder.decode(ArtistResponse.self, from: data)
                print("✅ searchArtists - Success: \(artistResponse.results.count) artists, page: \(page)")
                return artistResponse
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
    
    func searchAlbums(searchText: String, page: Int = 1) async throws -> AlbumResponse {
        print("searchAlbums - page: \(page)")
        let url = SearchEndpoint.albums(searchText, page: page).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchAlbums - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchAlbums - HTTP error \(httpResponse.statusCode)")
                throw APError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let albumResponse = try decoder.decode(AlbumResponse.self, from: data)
            print("✅ searchAlbums - Success: \(albumResponse.results.count) albums, page: \(page)")
            return albumResponse
        } catch {
            print("❌ searchAlbums - Network error: \(error)")
            throw error
        }
    }
    
    func searchPlaylists(searchText: String, page: Int = 1) async throws -> PlaylistResponse {
        print("searchPlaylists - page: \(page)")
        let url = SearchEndpoint.playlists(searchText, page: page).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchPlaylists - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchPlaylists - HTTP error \(httpResponse.statusCode)")
                throw APError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let playlistResponse = try decoder.decode(PlaylistResponse.self, from: data)
            print("✅ searchPlaylists - Success: \(playlistResponse.results.count) playlists, page: \(page)")
            return playlistResponse
        } catch {
            print("❌ searchPlaylists - Network error: \(error)")
            throw error
        }
    }
    
    func searchProfiles(searchText: String, page: Int = 1) async throws -> UserResponse {
        print("searchProfiles - page: \(page)")
        let url = SearchEndpoint.profiles(searchText, page: page).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ searchProfiles - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ searchProfiles - HTTP error \(httpResponse.statusCode)")
                throw APError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let userResponse = try decoder.decode(UserResponse.self, from: data)
            print("✅ searchProfiles - Success: \(userResponse.results.count) profiles, page: \(page)")
            return userResponse
        } catch {
            print("❌ searchProfiles - Network error: \(error)")
            throw error
        }
    }
}
