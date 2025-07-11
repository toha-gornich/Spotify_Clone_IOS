//
//  ArtistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import Foundation

@MainActor final class PlaylistViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var popTracks: [Track] = []
    @Published var artists: [Artist] = []
    @Published var artist: Artist = Artist.empty
    @Published var albums: [Album] = []
    @Published var playlists: [Playlist] = []
    @Published var playlist: PlaylistDetail = PlaylistDetail.empty
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    @Published var album: Album = Album.empty
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Artists
    
    func getArtists() {
        isLoading = true
        
        Task {
            do {
                let fetchedArtists = try await networkManager.getArtists()
               
                artists = fetchedArtists
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getPlaylistBySlug(slug: String) {
        isLoading = true
        
        Task {
            do {
                playlist = try await networkManager.getPlaylistsBySlug(slug: slug)
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    // MARK: - Tracks
    
    func getTracks() {
        isLoading = true
        
        Task {
            do {
                let fetchedTracks = try await networkManager.getTracks()
                popTracks = fetchedTracks
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getTracksBySlugArtist(slug: String) {
        isLoading = true
        
        Task {
            do {
                let fetchedTracks = try await networkManager.getTracksBySlugArtist(slug: slug)
                tracks = fetchedTracks
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    // MARK: - Albums
    
    func getAlbums() {
        isLoading = true
        
        Task {
            do {
                let fetchedAlbums = try await networkManager.getAlbums()
                albums = fetchedAlbums
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getAlbumsBySlugArtist(slug: String) {
        isLoading = true
        
        Task {
            do {
                let fetchedAlbums = try await networkManager.getAlbumsBySlugArtist(slug: slug)
                albums = fetchedAlbums
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
//    // MARK: - Playlists
//    
//    func getPlaylists() {
//        isLoading = true
//        
//        Task {
//            do {
//                let fetchedPlaylists = try await networkManager.getPlaylists()
//                playlists = fetchedPlaylists
//                isLoading = false
//            } catch {
//                handleError(error)
//                isLoading = false
//            }
//        }
//    }
    
    // MARK: - Error Handling
    
    private func handleError(_ error: Error) {
        if let apError = error as? APError {
            switch apError {
            case .invalidResponse:
                alertItem = AlertContext.invalidResponse
            case .invalidURL:
                alertItem = AlertContext.invalidURL
            case .invalidData:
                alertItem = AlertContext.invalidData
            case .unableToComplete:
                alertItem = AlertContext.unableToComplete
            }
        } else {
            alertItem = AlertContext.invalidResponse
        }
    }
}
