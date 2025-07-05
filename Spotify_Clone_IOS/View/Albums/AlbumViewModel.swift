//
//  ArtistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import Foundation

@MainActor final class AlbumViewModel: ObservableObject {
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
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Artists
    
    func getArtists() {
        isLoading = true
        
        Task{
            do{
                artists = try await NetworkManager.shared.getArtists()
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    
    func getArtistsBySlug(slug:String) {
        isLoading = true
        
        Task{
            do{
                artist = try await NetworkManager.shared.getArtistsBySlug(slug: slug)
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    
    
    // MARK: - Tracks
    
    func getTracks() {
        isLoading = true
        
        Task{
            do{
                popTracks = try await NetworkManager.shared.getTracks()
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    

    func getTracksBySlugArtist(slug:String) {
        isLoading = true
        Task{
            do{
                tracks = try await NetworkManager.shared.getTracksBySlugArtist(slug: slug)
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    
    
    // MARK: - Albums
    func getAlbums() {
        isLoading = true
        
        Task{
            do{
                albums = try await NetworkManager.shared.getAlbums()
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    func getAlbumsBySlugArtist(slug:String) {
        isLoading = true
        Task{
            do{
                albums = try await NetworkManager.shared.getAlbumsBySlugArtist(slug: slug)
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    
    func getPlaylists() {
        isLoading = true
        
        Task{
            do{
                playlists = try await NetworkManager.shared.getPlaylists()
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
}
