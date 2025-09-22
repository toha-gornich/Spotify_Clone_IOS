//
//  ProfileView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//

import SwiftUI

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var user = UserMe.empty()
    @Published var name = ""
    @Published var followingCount: String = ""
    @Published var followersCount: String = ""
    @Published var playlistsCount: String = ""
    @Published var selectedSlugPlaylist: String = ""
    @Published var image: String = ""
    @Published var color:Color = Color.bg
    @Published var playlists: [Playlist] = []
    @Published var playlistTitles: [String] = []
    @Published var playlistImages: [String] = []
    @Published var playlistAuthors: [String] = []
    
    @Published var showPlaylist = false
    @Published var isLoading = false
    private let networkManager = NetworkManager.shared
    
    
    func getUserMe() async {
        isLoading = true

        do {
            let fetchedUser = try await networkManager.getUserMe()
            
            await MainActor.run {
                user = fetchedUser
                color = Color(hex: user.color!)
                name = user.displayName!
                playlistsCount = String(user.playlistsCount)
                image = user.image!
                followingCount = String(user.followingCount)
                followersCount = String(user.followersCount)
                isLoading = false
            }
            
        } catch {
            await MainActor.run {
                handleError(error)
                isLoading = false
            }
        }
    }

    func loadPlaylists() async {
        guard user.id != 0 else {
            print("❌ User ID is not available yet")
            return
        }
        
        isLoading = true

        do {
            let fetchedPlaylists = try await networkManager.getPlaylistsByIdUser(idUser: user.id)
            
            await MainActor.run {
                playlists = fetchedPlaylists
                isLoading = false
            }
            
        } catch {
            await MainActor.run {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    var themeColor: Color {
        if !user.color!.isEmpty {
            return Color(hex: user.color!)
        }
        return Color.pink
    }
    
    func followUser() {
//        print("Following user: \(userProfile.name)")
    }
    
    func shareProfile() {
//        print("Sharing profile of: \(userProfile.name)")
    }
    
    func showMoreOptions() {
//        print("Showing more options for: \(userProfile.name)")
    }
    
    func showAllPlaylists() {
        print("Showing all playlists")
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

