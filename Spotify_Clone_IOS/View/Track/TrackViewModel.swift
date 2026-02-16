//
//  ArtistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import Foundation
@MainActor final class TrackViewModel: ObservableObject {
    @Published var currentTrack: Track?
    @Published var track: TrackDetail = MockData.trackDetail
    @Published var artists: [Artist] = []
    @Published var tracks: [Track] = []
    @Published var tracksByArtist: [Track] = []
    @Published var artist: Artist = Artist.empty
    @Published var album: Album = Album.empty
    @Published var albums: [Album] = []
    @Published var playlists: [Playlist] = []
    @Published var isLoading: Bool = false
    @Published var isTrackLiked: Bool = false
    
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    var playableTrack: Track {
            return track.toTrack()
        }

    
    private let trackManager: TrackScreenServiceProtocol
    init(trackManager:TrackScreenServiceProtocol = NetworkManager.shared ){
        self.trackManager = trackManager
    }
    
    func getTrackBySlug(slug: String) {
        isLoading = true
        
        Task {
            do {
                
                let fetchedTrack = try await trackManager.getTrackBySlug(slug: slug)
                track = fetchedTrack
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    

    func postTrackFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await trackManager.postLikeTrack(slug: slug)
                
                // if successful (204) - track liked
                isTrackLiked = true
                isLoading = false
                
            } catch FavoriteError.alreadyLiked {
                // Track liked
                isTrackLiked = true
                isLoading = false
                
            } catch {
                // Another error
                isTrackLiked = false
                handleError(error)
                isLoading = false
            }
        }
    }
    func deleteTrackFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await trackManager.deleteTrackLike(slug: slug)

                isTrackLiked = false
                isLoading = false

                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    func getTrackBySlugArtist(slug: String) {
        isLoading = true
        
        Task {
            do {
                
                let fetchedTrack = try await trackManager.getTracksBySlugArtist(slug: slug)
                tracksByArtist = fetchedTrack
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getTracksBySlugGenre(slug: String) {
        isLoading = true
        
        Task {
            do {
                let fetchedTracks = try await trackManager.getTracksBySlugGenre(slug: slug)
                tracks = fetchedTracks
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
                let fetchedArtists = try await trackManager.getArtists()
               
                artists = fetchedArtists
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
                let fetchedAlbum = try await trackManager.getAlbumsBySlugArtist(slug: slug)
                albums = fetchedAlbum
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
