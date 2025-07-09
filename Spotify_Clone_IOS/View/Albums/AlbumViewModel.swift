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
    @Published var playlists: [Playlist] = []
    @Published var isLoading: Bool = false
    
    
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Albums
    
    func getAlbumBySlug(slug: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedAlbum = try await networkManager.getAlbumBySlug(slug: slug)
                album = fetchedAlbum
                isLoading = false
                
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
                
                let fetchedTracks = try await networkManager.getTracksBySlugAlbum(slug: slug)
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
                let fetchedTracks = try await networkManager.getTracksBySlugArtist(slug: slug)
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
