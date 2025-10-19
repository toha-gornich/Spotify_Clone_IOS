//
//  AccountViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//
import Foundation
import SwiftUI

@MainActor
final class ArtistTracksViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var tracks: [TracksMy] = []
    @Published var searchText = ""
    @Published var selectedFilter: TrackFilter = .all
    @Published var isLoading = false
    @Published var showCreateTrack = false
    @Published var showEditTrack = false
    @Published var showOnlyPrivateTracks = false
    
    private let trackMyService: MyTracksServiceProtocol
    
    init(trackMyService: MyTracksServiceProtocol = NetworkManager.shared){
        self.trackMyService = trackMyService
    }
    
    private let networkManager = NetworkManager.shared
    
    enum TrackFilter: String, CaseIterable {
        case all = "All"
        case `private` = "Private"
        
        var title: String {
            return self.rawValue
        }
    }
    
    var filteredTracks: [TracksMy] {
        var result = tracks
        
        // Apply private filter
        if showOnlyPrivateTracks {
            result = result.filter { $0.isPrivate == true }
        }
        
        // Apply tab filter
        if selectedFilter == .private {
            result = result.filter { $0.isPrivate == true }
        }
        
        // Apply search
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.albumTitle.localizedCaseInsensitiveContains(searchText) ||
                $0.genreName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    func filterPrivateTracks(_ showOnlyPrivate: Bool) {
        showOnlyPrivateTracks = showOnlyPrivate
    }
    
    func getTracksMy() {
        isLoading = true
    
        Task {
            do {
                let fetchedTracks = try await trackMyService.getTracksMy()
                tracks = fetchedTracks
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func deleteTrack(slug: String) {
        isLoading = true
    
        Task {
            do {
                try await trackMyService.deleteTracksMy(slug: slug)
                getTracksMy()
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func loadTracksData() {
        // Implement if needed
    }
    
    func togglePrivacy(track: TracksMy) {
        isLoading = true
        
        Task {
            do {
                try await trackMyService.patchTracksMy(slug: track.slug, isPrivate: !track.isPrivate, retryCount: 0)
                getTracksMy()
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func searchTracks() {
        // Search functionality is handled by computed property
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
