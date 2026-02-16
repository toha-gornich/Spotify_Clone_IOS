//
//  HomeViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import SwiftUI

// HomeViewModel.swift
@MainActor final class HomeViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var artists: [Artist] = []
    @Published var albums: [Album] = []
    @Published var playlists: [Playlist] = []
    @Published var user = UserMy.empty()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var alertItem: AlertItem?
    
    private var tracksLoaded = false
    private var artistsLoaded = false
    private var albumsLoaded = false
    private var playlistsLoaded = false
    private var userLoaded = false
    
    private var lastRefreshDate: Date?
    private let cacheValidityDuration: TimeInterval = 300 // 5 minutes
    
    private let homeService: HomeServiceProtocol
    
    init(homeService: HomeServiceProtocol = NetworkManager.shared) {
        self.homeService = homeService
    }
    
    
    func getTracks(forceRefresh: Bool = false) {
        print("🔵 getTracks called")
        print("🔵 tracksLoaded: \(tracksLoaded)")
        print("🔵 shouldRefreshCache: \(shouldRefreshCache())")
        
        guard !tracksLoaded || forceRefresh || shouldRefreshCache() else {
            print("✅ Tracks already loaded, skipping")
            return
        }
        
        print("🔴 Starting tracks request")
        isLoading = true
        
        Task {
            do {
                tracks = try await homeService.getTracks()
                print("✅ Tracks loaded: \(tracks.count)")
                tracksLoaded = true
                updateRefreshDate()
                isLoading = false
            } catch {
                print("❌ Tracks error: \(error)")
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getArtists(forceRefresh: Bool = false) {
        guard !artistsLoaded || forceRefresh || shouldRefreshCache() else { return }
        
        isLoading = true
        
        Task {
            do {
                artists = try await homeService.getArtists()
                artistsLoaded = true
                updateRefreshDate()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getAlbums(forceRefresh: Bool = false) {
        guard !albumsLoaded || forceRefresh || shouldRefreshCache() else { return }
        
        isLoading = true
        
        Task {
            do {
                albums = try await homeService.getAlbums()
                albumsLoaded = true
                updateRefreshDate()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getPlaylists(forceRefresh: Bool = false) {
        guard !playlistsLoaded || forceRefresh || shouldRefreshCache() else { return }
        
        isLoading = true
        
        Task {
            do {
                playlists = try await homeService.getPlaylists()
                playlistsLoaded = true
                updateRefreshDate()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getUserMe(forceRefresh: Bool = false) {
        guard !userLoaded || forceRefresh || shouldRefreshCache() else { return }
        
        isLoading = true
    
        Task {
            do {
                user = try await homeService.getProfileMy()
                userLoaded = true
                updateRefreshDate()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    // MARK: - Cache Management
    
    func loadAllDataIfNeeded() {
        print("🟡 loadAllDataIfNeeded called")
        print("🟡 tracksLoaded: \(tracksLoaded)")
        print("🟡 artistsLoaded: \(artistsLoaded)")
        getTracks()
        getArtists()
        getAlbums()
        getPlaylists()
        getUserMe()
    }
    
    func refreshAllData() {
        getTracks(forceRefresh: true)
        getArtists(forceRefresh: true)
        getAlbums(forceRefresh: true)
        getPlaylists(forceRefresh: true)
        getUserMe(forceRefresh: true)
    }
    
    func clearCache() {
        tracksLoaded = false
        artistsLoaded = false
        albumsLoaded = false
        playlistsLoaded = false
        userLoaded = false
        lastRefreshDate = nil
        
        tracks = []
        artists = []
        albums = []
        playlists = []
        user = UserMy.empty()
    }
    
    private func shouldRefreshCache() -> Bool {
        guard let lastRefresh = lastRefreshDate else { return true }
        return Date().timeIntervalSince(lastRefresh) > cacheValidityDuration
    }
    
    private func updateRefreshDate() {
        lastRefreshDate = Date()
    }
    
    // MARK: - Error Handling
    
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
