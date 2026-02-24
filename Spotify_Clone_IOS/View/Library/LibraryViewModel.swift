//
//  LibraryViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 09.10.2025.
//


import SwiftUI

@MainActor final class LibraryViewModel: ObservableObject {
    @Published var likedTracks: [Track] = []
    @Published var playlists: [Playlist] = []
    @Published var artists: [ArtistTrack] = []
    @Published var playlist = PlaylistDetail.empty
    @Published var user = UserMy.empty()
    @Published var albums: [Album] = []
    @Published var selectedTab: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var alertItem: AlertItem?
    @Published var showNewPlaylist = false 
    
    private let libraryManager: LibraryServiceProtocol
    init(libraryManager:LibraryServiceProtocol = NetworkManager.shared){
        self.libraryManager = libraryManager
    }
    
    func loadLibraryData() {
        getLikedTracks()
        getPlaylists()
        getArtists()
        getAlbums()
    }
    func createPlaylist() {
        isLoading = true
        showNewPlaylist = false
        
        Task {
            do {
                playlist = try await libraryManager.postMyPlaylist()
                isLoading = false
                showNewPlaylist = true
            } catch {
                handleError(error)
                isLoading = false
            }
        }

    }
    
    func getLikedTracks() {
        isLoading = true
        Task {
            do {
                likedTracks = try await libraryManager.getTracksLiked()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getPlaylists() {
        isLoading = true
        
        Task {
            do {
                let fetchedPlaylists = try await libraryManager.getPlaylistsFavorite()
                playlists = FavoritePlaylistItem.toPlaylists(fetchedPlaylists)
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getArtists() {
        isLoading = true
        
        Task {
            do {
                let fetchedArtists = try await libraryManager.getArtistsFavorite()
                artists = FavoriteArtistItem.toArtists(fetchedArtists)
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getAlbums() {
        isLoading = true
        
        Task {
            do {
                let fetchedAlbums = try await libraryManager.getAlbumsFavorite()
                albums = FavoriteAlbumItem.toAlbums(fetchedAlbums)
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getUserMe() {
        isLoading = true
    
        Task {
            do {
                user = try await libraryManager.getProfileMy()
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
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
