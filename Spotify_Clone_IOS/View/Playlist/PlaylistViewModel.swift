//
//  ArtistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import Foundation

@MainActor final class PlaylistViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var albums: [Album] = []
    @Published var playlists: [Playlist] = []
    @Published var playlist: PlaylistDetail = PlaylistDetail.empty
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    @Published var isPlaylistLiked: Bool = false
    @Published var album: Album = Album.empty
    

    var totalDuration: String {
        let totalSeconds = playlist.tracks.reduce(0) { $0 + $1.durationInSeconds }
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private let playlistManager: PlaylistServiceProtocol
    init(playlistManager: PlaylistServiceProtocol = NetworkManager.shared){
        self.playlistManager = playlistManager
    }
    
    func postPlaylistFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await playlistManager.postAddFavoritePlaylist(slug: slug)
                
                // if successful (204) - track liked
                isPlaylistLiked = true
                isLoading = false
                
            } catch FavoriteError.alreadyLiked {
                // Track liked
                isPlaylistLiked = true
                isLoading = false
                
            } catch {
                // Another error
                isPlaylistLiked = false
                handleError(error)
                isLoading = false
            }
        }
    }
    func deletePlaylistFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await playlistManager.deletePlaylistFavorite(slug: slug)

                isPlaylistLiked = false
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
                playlist = try await playlistManager.getPlaylistsBySlug(slug: slug)
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
