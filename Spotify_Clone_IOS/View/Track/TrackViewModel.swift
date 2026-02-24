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
    
    private var likedTracks: [Track] = []
    
    var playableTrack: Track {
            return track.toTrack()
        }

    private let trackManager: TrackScreenServiceProtocol
    init(trackManager:TrackScreenServiceProtocol = NetworkManager.shared ){
        self.trackManager = trackManager
    }
    
    func getTrackBySlug(slug: String) async {
        isLoading = true
        do {
            let fetchedTrack = try await trackManager.getTrackBySlug(slug: slug)
            track = fetchedTrack
            currentTrack = fetchedTrack.toTrack()
            await getTracksLiked()
            isLoading = false
        } catch {
            handleError(error)
            isLoading = false
        }
    }
    

    func postTrackFavorite(slug: String) {
        isTrackLiked = true
        Task {
            do {
                try await trackManager.postLikeTrack(slug: slug)
                await getTracksLiked() 
            } catch FavoriteError.alreadyLiked {
                isTrackLiked = true
            } catch {
                isTrackLiked = false
                handleError(error)
            }
        }
    }

    func deleteTrackFavorite(slug: String) {
        isTrackLiked = false
        Task {
            do {
                try await trackManager.deleteTrackLike(slug: slug)
                await getTracksLiked()
            } catch {
                isTrackLiked = true
                handleError(error)
            }
        }
    }
    
    func getTracksLiked() async {
        do {
            likedTracks = try await trackManager.getTracksLiked()
            isTrackLiked = likedTracks.contains { $0.slug == currentTrack?.slug }
        } catch {
            handleError(error)
        }
    }
    
    func getTracksBySlugGenre(slug: String) async {
        isLoading = true
        do {
            let fetchedTracks = try await trackManager.getTracksBySlugGenre(slug: slug)
            self.tracks = fetchedTracks
            isLoading = false
        } catch {
            handleError(error)
            isLoading = false
        }
    }

    func getTrackBySlugArtist(slug: String) async {
        isLoading = true
        do {
            let fetchedTrack = try await trackManager.getTracksBySlugArtist(slug: slug)
            self.tracksByArtist = fetchedTrack
            isLoading = false
        } catch {
            handleError(error)
            isLoading = false
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
