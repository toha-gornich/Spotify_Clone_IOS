//
//  NetworkManager+Search.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: SearchServiceProtocol {
    func searchTracks(searchText:String) async throws -> [Track] {
        print("searchTracks")
        guard let url = URL(string: Constants.API.searchTracksURL + "\(searchText)") else {
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
    
    func searchArtists(searchText:String) async throws -> [Artist] {
        print("searchArtists")
        guard let url = URL(string: Constants.API.searchArtistsURL + "\(searchText)") else {
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
    
    func searchAlbums(searchText:String) async throws -> [Album] {
        print("searchAlbums")
        guard let url = URL(string: Constants.API.searchAlbumsURL + "\(searchText)") else {
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
    
    func searchPlaylists(searchText:String) async throws -> [Playlist] {
        print("searchPlaylists")
        guard let url = URL(string: Constants.API.searchPlaylistsURL + "\(searchText)") else {
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
    
    func searchProfiles(searchText:String) async throws -> [User] {
        print("searchProfiles")
        guard let url = URL(string: Constants.API.searchProfilesURL + "\(searchText)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(UserResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
}
