//
//  LibraryViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 09.10.2025.
//


import SwiftUI

@MainActor final class LibraryViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var artists: [ArtistTrack] = []
    @Published var albums: [Album] = []
    @Published var selectedTab: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var alertItem: AlertItem?
    
    private let networkManager = NetworkManager.shared
    
    func loadLibraryData() {
        getPlaylists()
        getArtists()
        getAlbums()
    }
    
    func getPlaylists() {
        isLoading = true
        
        Task {
            do {
                let fetchedPlaylists = try await networkManager.getPlaylistsFavorite()
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
                let fetchedArtists = try await networkManager.getArtistsFavorite()
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
                let fetchedAlbums = try await networkManager.getAlbumsFavorite()
                albums = FavoriteAlbumItem.toAlbums(fetchedAlbums)
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
