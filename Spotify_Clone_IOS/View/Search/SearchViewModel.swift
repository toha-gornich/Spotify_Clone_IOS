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
    @Published var user = UserMy.empty()
    
    @Published var isLoadingMoreTracks: Bool = false
    @Published var isLoadingMoreArtists: Bool = false
    @Published var isLoadingMoreAlbums: Bool = false
    @Published var isLoadingMorePlaylists: Bool = false
    @Published var isLoadingMoreProfiles: Bool = false
    
    private var currentTracksPage: Int = 1
    private var currentArtistsPage: Int = 1
    private var currentAlbumsPage: Int = 1
    private var currentPlaylistsPage: Int = 1
    private var currentProfilesPage: Int = 1
    
    private var hasMoreTracks: Bool = false
    private var hasMoreArtists: Bool = false
    private var hasMoreAlbums: Bool = false
    private var hasMorePlaylists: Bool = false
    private var hasMoreProfiles: Bool = false
    
    private var tracksSearchText: String = ""
    private var artistsSearchText: String = ""
    private var albumsSearchText: String = ""
    private var playlistsSearchText: String = ""
    private var profilesSearchText: String = ""
    
    private var lastTracksLoadTime: Date = .distantPast
    private var lastArtistsLoadTime: Date = .distantPast
    private var lastAlbumsLoadTime: Date = .distantPast
    private var lastPlaylistsLoadTime: Date = .distantPast
    private var lastProfilesLoadTime: Date = .distantPast
    
    private let searchManager: SearchServiceProtocol
    private let userManager: UserServiceProtocol
    
    init(searchManager: SearchServiceProtocol = NetworkManager.shared, userManager: UserServiceProtocol = NetworkManager.shared) {
        self.searchManager = searchManager
        self.userManager = userManager
        getUserMe()
    }
    
    // MARK: - Tracks
    func searchTracks(searchText: String) {
        tracks = []
        currentTracksPage = 1
        tracksSearchText = searchText
        hasMoreTracks = false
        isLoading = true
    
        Task {
            do {
                let response = try await searchManager.searchTracks(searchText: searchText, page: 1)
                tracks = response.results
                hasMoreTracks = response.next != nil
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func loadMoreTracks() {
        let now = Date()
        guard now.timeIntervalSince(lastTracksLoadTime) > 0.5 else {
            return
        }
        
        guard !isLoadingMoreTracks, hasMoreTracks, !tracksSearchText.isEmpty else {
            return
        }
        
        lastTracksLoadTime = now
        isLoadingMoreTracks = true
        currentTracksPage += 1

        Task {
            do {
                let response = try await searchManager.searchTracks(searchText: tracksSearchText, page: currentTracksPage)
                
                _ = tracks.count
                tracks.append(contentsOf: response.results)
                _ = tracks.count
                
                hasMoreTracks = response.next != nil
                isLoadingMoreTracks = false
            } catch {
                handleError(error)
                isLoadingMoreTracks = false
                currentTracksPage -= 1
            }
        }
    }
    
    // MARK: - Artists
    func searchArtists(searchText: String) {
        artists = []
        currentArtistsPage = 1
        artistsSearchText = searchText
        hasMoreArtists = false
        isLoading = true
    
        Task {
            do {
                let response = try await searchManager.searchArtists(searchText: searchText, page: 1)
                artists = response.results
                hasMoreArtists = response.next != nil
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func loadMoreArtists() {
        let now = Date()
        guard now.timeIntervalSince(lastArtistsLoadTime) > 0.5 else {
            return
        }
        
        guard !isLoadingMoreArtists, hasMoreArtists, !artistsSearchText.isEmpty else {
            return
        }
        
        lastArtistsLoadTime = now
        isLoadingMoreArtists = true
        currentArtistsPage += 1
        
        Task {
            do {
                let response = try await searchManager.searchArtists(searchText: artistsSearchText, page: currentArtistsPage)
                artists.append(contentsOf: response.results)
                hasMoreArtists = response.next != nil
                isLoadingMoreArtists = false
            } catch {
                handleError(error)
                isLoadingMoreArtists = false
                currentArtistsPage -= 1
            }
        }
    }
    
    // MARK: - Albums
    func searchAlbums(searchText: String) {
        print("🔍 SearchVM - searchAlbums called with: '\(searchText)'")
        albums = []
        currentAlbumsPage = 1
        albumsSearchText = searchText
        hasMoreAlbums = false
        isLoading = true
    
        Task {
            do {
                let response = try await searchManager.searchAlbums(searchText: searchText, page: 1)
                albums = response.results
                hasMoreAlbums = response.next != nil
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func loadMoreAlbums() {
        let now = Date()
        guard now.timeIntervalSince(lastAlbumsLoadTime) > 0.5 else {
            return
        }
        
        guard !isLoadingMoreAlbums, hasMoreAlbums, !albumsSearchText.isEmpty else {
            return
        }
        
        lastAlbumsLoadTime = now
        isLoadingMoreAlbums = true
        currentAlbumsPage += 1
        
        Task {
            do {
                let response = try await searchManager.searchAlbums(searchText: albumsSearchText, page: currentAlbumsPage)
                albums.append(contentsOf: response.results)
                hasMoreAlbums = response.next != nil
                isLoadingMoreAlbums = false
            } catch {
                handleError(error)
                isLoadingMoreAlbums = false
                currentAlbumsPage -= 1
            }
        }
    }
    
    // MARK: - Playlists
    func searchPlaylists(searchText: String) {
        playlists = []
        currentPlaylistsPage = 1
        playlistsSearchText = searchText
        hasMorePlaylists = false
        isLoading = true
    
        Task {
            do {
                let response = try await searchManager.searchPlaylists(searchText: searchText, page: 1)
                playlists = response.results
                hasMorePlaylists = response.next != nil
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func loadMorePlaylists() {
        let now = Date()
        guard now.timeIntervalSince(lastPlaylistsLoadTime) > 0.5 else {
            return
        }
        
        guard !isLoadingMorePlaylists, hasMorePlaylists, !playlistsSearchText.isEmpty else {
            return
        }
        
        lastPlaylistsLoadTime = now
        isLoadingMorePlaylists = true
        currentPlaylistsPage += 1

        
        Task {
            do {
                let response = try await searchManager.searchPlaylists(searchText: playlistsSearchText, page: currentPlaylistsPage)
                playlists.append(contentsOf: response.results)
                hasMorePlaylists = response.next != nil
                isLoadingMorePlaylists = false
            } catch {
                handleError(error)
                isLoadingMorePlaylists = false
                currentPlaylistsPage -= 1
            }
        }
    }
    
    // MARK: - Profiles
    func searchProfiles(searchText: String) {
        profiles = []
        currentProfilesPage = 1
        profilesSearchText = searchText
        hasMoreProfiles = false
        isLoading = true
    
        Task {
            do {
                let response = try await searchManager.searchProfiles(searchText: searchText, page: 1)
                profiles = response.results
                hasMoreProfiles = response.next != nil
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func loadMoreProfiles() {
        let now = Date()
        guard now.timeIntervalSince(lastProfilesLoadTime) > 0.5 else {
            return
        }
        
        guard !isLoadingMoreProfiles, hasMoreProfiles, !profilesSearchText.isEmpty else {
            return
        }
        
        lastProfilesLoadTime = now
        isLoadingMoreProfiles = true
        currentProfilesPage += 1
        
        Task {
            do {
                let response = try await searchManager.searchProfiles(searchText: profilesSearchText, page: currentProfilesPage)
                profiles.append(contentsOf: response.results)
                hasMoreProfiles = response.next != nil
                isLoadingMoreProfiles = false
            } catch {
                handleError(error)
                isLoadingMoreProfiles = false
                currentProfilesPage -= 1
            }
        }
    }
    
    // MARK: - User
    func getUserMe() {
        isLoading = true
    
        Task {
            do {
                user = try await userManager.getProfileMy()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    // MARK: - Error Handling
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
