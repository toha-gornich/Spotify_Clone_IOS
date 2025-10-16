//
//  ArtistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import Foundation

@MainActor final class ArtistViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var popTracks: [Track] = []
    @Published var artists: [Artist] = []
    @Published var artist: Artist = Artist.empty
    @Published var albums: [Album] = []
    @Published var playlists: [Playlist] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    @Published var isTrackLiked: Bool = false
    @Published var isFollowing: Bool = false
    
    @Published var album: Album = Album.empty
    
    private let networkManager = NetworkManager.shared
    
    func getArtistsBySlug(slug: String) {
        isLoading = true
        
        Task {
            do {
                let fetchedArtist = try await networkManager.getArtistsBySlug(slug: slug)
                artist = fetchedArtist
                

                await checkFollowStatus(userId: String(artist.id))
                
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }

    
    func checkFollowStatus(userId: String) async {
        do {
            try await networkManager.postFollowArtist(userId: userId)
            
            await MainActor.run {
                isFollowing = true
                
            }
            
            try? await networkManager.postUnfollowArtist(userId: userId)
            await MainActor.run {
                isFollowing = false

            }
            
        } catch FavoriteError.alreadyLiked {
            await MainActor.run {
                isFollowing = true

            }
            
        } catch {

            await MainActor.run {
                isFollowing = false

            }
        }
    }

    func followArtist(userId: String) {
        isFollowing = true
        isLoading = true
        
        Task {
            do {
                try await networkManager.postFollowArtist(userId: userId)
                
                await MainActor.run {
                    isLoading = false

                }
                
            } catch FavoriteError.alreadyLiked {
                await MainActor.run {
                    isFollowing = true
                    isLoading = false
                    
                }
                
            } catch {
                await MainActor.run {
                    isFollowing = false
                    isLoading = false
                    handleError(error)
                }
            }
        }
    }

    func unfollowArtist(userId: String) {
        isFollowing = false
        isLoading = true
        
        Task {
            do {
                try await networkManager.postUnfollowArtist(userId: userId)
                
                await MainActor.run {
                    isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    isFollowing = true
                    isLoading = false
                    handleError(error)
                }
            }
        }
    }
    

    
    func postArtistFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await networkManager.postAddFavoriteArtist(slug: slug)
                
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
    func deleteArtistFavorite(slug: String) {
        isLoading = true
        
        Task {
            do {
                try await networkManager.deleteArtistFavorite(slug: slug)

                isTrackLiked = false
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
                let fetchedArtists = try await networkManager.getArtists()
               
                artists = fetchedArtists
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }


    
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
