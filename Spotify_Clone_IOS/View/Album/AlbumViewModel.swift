//
//  ArtistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import Foundation
@MainActor final class AlbumViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var artists: [Artist] = []
    @Published var tracksByArtist: [Track] = []
    @Published var artist: Artist = Artist.empty
    @Published var album: Album = Album.empty
    @Published var albums: [Album] = []
    @Published var albumsFavorite: [FavoriteAlbumItem] = []
    @Published var playlists: [Playlist] = []
    @Published var isLoading: Bool = false
    @Published var isAlbumLiked: Bool = false
    
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    
    var totalDuration: String {
        let totalSeconds = tracks.reduce(0) { $0 + $1.durationInSeconds }
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private let albumManager: AlbumArtistServiceProtocol
    init(albumManager:AlbumArtistServiceProtocol = NetworkManager.shared){
        self.albumManager = albumManager
    }
    
    
    
    // MARK: - Albums
    
    func postAlbumFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await albumManager.postAddFavoriteAlbum(slug: slug)
                
                // if successful (204) - track liked
                isAlbumLiked = true
                isLoading = false
                
            } catch FavoriteError.alreadyLiked {
                // Track liked
                isAlbumLiked = true
                isLoading = false
                
            } catch {
                // Another error
                isAlbumLiked = false
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getAlbumLicked() async {
        do {
            albumsFavorite = try await albumManager.getAlbumsFavorite()
            isAlbumLiked = albumsFavorite.contains { $0.album.slug == album.slug }
        } catch {
            handleError(error)
        }
    }
    
    func deleteAlbumFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await albumManager.deleteAlbumsFavorite(slug: slug)

                isAlbumLiked = false
                isLoading = false

                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getAlbumBySlug(slug: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedAlbum = try await albumManager.getAlbumBySlug(slug: slug)
                album = fetchedAlbum
                isLoading = false
                await getAlbumLicked()
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    func getTracksBySlugAlbum(slug: String) {
        isLoading = true
        
        Task {
            do {
                
                let fetchedTracks = try await albumManager.getTracksBySlugAlbum(slug: slug)
                tracks = fetchedTracks
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
                let fetchedTracks = try await albumManager.getTracksBySlugArtist(slug: slug)
                tracksByArtist = fetchedTracks
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func handleError(_ error: Error) {
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
