    //
//  HomeViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import SwiftUI
@MainActor final class GenresViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var playlists: [Playlist] = []
    @Published var genres: [Genre] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    @Published var genre: Genre = Genre.empty()
    
    private let networkManager = NetworkManager.shared
    
    func getGenres() {
        isLoading = true
        
        Task {
            do {
                genres = try await NetworkManager.shared.getGenres()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getPlaylistsBySlugGenre(slug: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedPlaylists = try await networkManager.getPlaylistsBySlugGenre(slug: slug)
                playlists = fetchedPlaylists
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
                let fetchedTracks = try await networkManager.getTracksBySlugGenre(slug: slug)
                tracks = fetchedTracks
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
  
    
    func getGenreBySlug(slug: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedGenre = try await networkManager.getGenreBySlug(slug: slug)
                genre = fetchedGenre
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
