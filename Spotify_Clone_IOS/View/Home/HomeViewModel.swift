//
//  HomeViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import SwiftUI

@MainActor final class HomeViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var artists: [Artist] = []
    @Published var albums: [Album] = []
    @Published var playlists: [Playlist] = []
    @Published var user = UserMy.empty()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    private let homeService: HomeServiceProtocol
    
    init(homeService: HomeServiceProtocol = NetworkManager.shared){
        self.homeService = homeService
    }
    
    func getTracks() {
        isLoading = true
        
        Task {
            do {
                tracks = try await homeService.getTracks()
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
                artists = try await homeService.getArtists()
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
                albums = try await homeService.getAlbums()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func getPlaylists() {
        isLoading = true
        
        Task {
            do {
                playlists = try await homeService.getPlaylists()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    func getUserMe() {
        isLoading = true
    
        Task {
            do {
                user = try await homeService.getProfileMy()
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
