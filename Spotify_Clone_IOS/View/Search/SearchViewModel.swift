//
//  HomeViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import SwiftUI
@MainActor final class SearchViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var artists: [Artist] = []
    @Published var albums: [Album] = []
    @Published var profiles: [User] = []
    @Published var playlists: [Playlist] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    private let searchManager: SearchServiceProtocol
    init(searchManager:SearchServiceProtocol = NetworkManager.shared ){
        self.searchManager = searchManager
    }
    

    func searchTracks(searchText: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedTracks = try await searchManager.searchTracks(searchText: searchText)
                tracks = fetchedTracks
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    func searchArtists(searchText: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedArtists = try await searchManager.searchArtists(searchText: searchText)
                artists = fetchedArtists
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    func searchAlbums(searchText: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedAlbums = try await searchManager.searchAlbums(searchText: searchText)
                albums = fetchedAlbums
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    
    func searchPlaylists(searchText: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedPlaylists = try await searchManager.searchPlaylists(searchText: searchText)
                playlists = fetchedPlaylists
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    
    func searchProfiles(searchText: String) {
        isLoading = true
    
        Task {
            do {
                let fetchedProfiles = try await searchManager.searchProfiles(searchText: searchText)
                profiles = fetchedProfiles
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let appError = error as? APError {
            switch appError {
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
