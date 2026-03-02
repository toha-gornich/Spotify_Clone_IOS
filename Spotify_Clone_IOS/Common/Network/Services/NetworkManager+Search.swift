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
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ searchTracks - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ searchTracks - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            let tracksResponse = try JSONDecoder().decode(TracksResponse.self, from: data)
            return tracksResponse
        } catch {
            print("❌ searchTracks - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func searchArtists(searchText: String, page: Int = 1) async throws -> ArtistResponse {
        print("searchArtists - page: \(page)")
        let url = SearchEndpoint.artists(searchText, page: page).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ searchArtists - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ searchArtists - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            let artistResponse = try JSONDecoder().decode(ArtistResponse.self, from: data)
            return artistResponse
        } catch {
            print("❌ searchArtists - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func searchAlbums(searchText: String, page: Int = 1) async throws -> AlbumResponse {
        print("searchAlbums - page: \(page)")
        let url = SearchEndpoint.albums(searchText, page: page).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ searchAlbums - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ searchAlbums - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: data)
            return albumResponse
        } catch {
            print("❌ searchAlbums - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func searchPlaylists(searchText: String, page: Int = 1) async throws -> PlaylistResponse {
        print("searchPlaylists - page: \(page)")
        let url = SearchEndpoint.playlists(searchText, page: page).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ searchPlaylists - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ searchPlaylists - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            let playlistResponse = try JSONDecoder().decode(PlaylistResponse.self, from: data)
            return playlistResponse
        } catch {
            print("❌ searchPlaylists - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func searchProfiles(searchText: String, page: Int = 1) async throws -> UserResponse {
        print("searchProfiles - page: \(page)")
        let url = SearchEndpoint.profiles(searchText, page: page).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ searchProfiles - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ searchProfiles - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
            return userResponse
        } catch {
            print("❌ searchProfiles - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
}
