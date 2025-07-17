//
//  ArtistViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import Foundation
@MainActor final class TrackViewModel: ObservableObject {
    @Published var track: TrackDetail = MockData.trackDetail
    @Published var artists: [Artist] = []
    @Published var tracksByArtist: [Track] = []
    @Published var artist: Artist = Artist.empty
    @Published var album: Album = Album.empty
    @Published var albums: [Album] = []
    @Published var playlists: [Playlist] = []
    @Published var isLoading: Bool = false
    
    
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    
//    var totalDuration: String {
//        let totalSeconds = tracks.reduce(0) { $0 + $1.durationInSeconds }
//        let minutes = Int(totalSeconds) / 60
//        let seconds = Int(totalSeconds) % 60
//        return String(format: "%d:%02d", minutes, seconds)
//    }

    
    private let networkManager = NetworkManager.shared
    
    func getTrackBySlug(slug: String) {
        isLoading = true
        
        Task {
            do {
                
                let fetchedTrack = try await networkManager.getTrackBySlug(slug: slug)
                track = fetchedTrack
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
