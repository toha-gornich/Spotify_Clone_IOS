//
//  MyPlaylistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI
import Foundation
import Combine

@MainActor
class MyPlaylistViewModel: ObservableObject {
    @Published var searchResults: [Track] = []
    @Published var isSearching: Bool = false
    @Published var playlist = PlaylistDetail.empty
    @Published var alertItem: AlertItem?
    @Published var isLoading: Bool = false
    
    private var searchTask: Task<Void, Never>?
    
    private var playlistManager: PlaylistServiceProtocol
    private var searchManager: SearchServiceProtocol
    
    init(playlistManager: PlaylistServiceProtocol = NetworkManager.shared,
         searchManager: SearchServiceProtocol = NetworkManager.shared
    ) {
        self.playlistManager = playlistManager
        self.searchManager = searchManager
    }
    
    
    func searchTracks(searchText: String) {
        // Cancel previous search task
        searchTask?.cancel()
        
        guard !searchText.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        searchTask = Task {
            isSearching = true
            
            // Debounce
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            
            guard !Task.isCancelled else {
                isSearching = false
                return
            }
            
            do {
                let fetchedTracks = try await searchManager.searchTracks(searchText: searchText)
                
                if !Task.isCancelled {
                    searchResults = fetchedTracks
                }
                isSearching = false
                
            } catch {
                if !Task.isCancelled {
                    handleError(error)
                }
                isSearching = false
            }
        }
    }
    
    func clearSearch() {
        searchTask?.cancel()
        searchResults = []
        isSearching = false
    }
    
    func getPlaylist(_ slugPlaylist: String) {
        isLoading = true
        
        Task {
            do {
                playlist = try await playlistManager.getPlaylistsBySlug(slug: slugPlaylist)
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    

    func addTrack(_ trackSlug: String) async -> Bool {
        do {
            try await playlistManager.postTrackToPlaylist(slug: playlist.slug, trackSlug: trackSlug)
            
            // Refresh playlist to get updated tracks list
            await refreshPlaylist()
            return true
            
        } catch {
            handleError(error)
            return false
        }
    }
    
    func removeTrack(_ trackSlug: String) async -> Bool {
        do {
            try await playlistManager.deleteTrackFromPlaylist(slug: playlist.slug, trackSlug: trackSlug)
            
            // Refresh playlist to get updated tracks list
            await refreshPlaylist()
            return true
            
        } catch {
            handleError(error)
            return false
        }
    }
    
    func deletePlaylist() async {
        isLoading = true
        
        do {
            try await playlistManager.deletePlaylist(slug: playlist.slug)
            isLoading = false
            
        } catch {
            handleError(error)
            isLoading = false
        }
    }
    
    func isTrackInPlaylist(_ trackSlug: String) -> Bool {
           return playlist.tracks?.contains(where: { $0.slug == trackSlug }) ?? false
       }
    
    private func refreshPlaylist() async {
        do {
            playlist = try await playlistManager.getPlaylistsBySlug(slug: playlist.slug)
        } catch {
            // Silent fail on refresh, main operation already succeeded
            print("Failed to refresh playlist: \(error)")
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
