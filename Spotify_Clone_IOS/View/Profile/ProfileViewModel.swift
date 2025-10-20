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
    @Published var followers:[User] = []
    @Published var following:[User] = []
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
    private let profileManager: ProfileScreenServiceProtocol
    
    init(profileManager: ProfileScreenServiceProtocol = NetworkManager.shared){
        self.profileManager = profileManager
    }
    
    
    func getUserMe(userId: String?) async {
        isLoading = true
        
        do {
            let userMe = try await profileManager.getUserMe()
            
            
            if let userId = userId {
                print("fdsfsdfdsf")
                print(String(userMe.id))
                print(userId)
                if String(userMe.id) == userId {
                    // Це мій профіль, використовуємо userMe
                    user = userMe
                } else {
                    // Це чужий профіль, робимо запит
                    user = try await profileManager.getUser(userId: userId)
                }
            } else {
                // Якщо userId немає, показуємо свій профіль
                user = userMe
            }

            // Тепер user доступний
            color = Color(hex: user.color!)
            name = user.displayName!
            playlistsCount = String(user.playlistsCount)
            image = user.image!
            followingCount = String(user.followingCount)
            followersCount = String(user.followersCount)
            isLoading = false
            await getFollowers()
            await getFollowing()
            
        } catch {
            handleError(error)
            isLoading = false
        }
    }
    
    func getFollowers() async {
        isLoading = true
        
        do {
            if user.id != 0{
                let fetchedFollowers = try await profileManager.getFollowers(userId: String(user.id))
                followers = fetchedFollowers
            }
            isLoading = false
            
        } catch {
            
            handleError(error)
            isLoading = false
        }
    }
    
    
    func getFollowing() async {
        isLoading = true
        
        do {
            if user.id != 0{
                let fetchedFollowing = try await profileManager.getFollowing(userId: String(user.id))
                following = fetchedFollowing
            }
            isLoading = false
        } catch {
            
            handleError(error)
            isLoading = false
            
        }
    }
    
    
    func loadPlaylists() async {
        guard user.id != 0 else {
            print("❌ User ID is not available yet")
            return
        }
        
        isLoading = true
        
        do {
            let fetchedPlaylists = try await profileManager.getPlaylistsByIdUser(idUser: user.id)
            
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
        
    }
    
    func shareProfile() {
        
    }
    
    func showMoreOptions() {
        
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

