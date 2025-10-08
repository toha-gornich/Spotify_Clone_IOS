//
//  AccountViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//
import Foundation
import SwiftUI

@MainActor
final class ArtistAlbumsViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var albums: [AlbumMy] = []
    @Published var searchText = ""
    @Published var selectedFilter: AlbumFilter = .all
    @Published var isLoading = false
    @Published var showCreateAlbum = false
    @Published var showEditAlbum = false
    @Published var showOnlyPrivateAlbums = false
    
    private let networkManager = NetworkManager.shared
    
    enum AlbumFilter: String, CaseIterable {
        case all = "All"
        case `private` = "Private"
        
        var title: String {
            return self.rawValue
        }
    }
    
    var filteredAlbums: [AlbumMy] {
        var result = albums
        
        // Apply private filter
        if showOnlyPrivateAlbums {
            result = result.filter { $0.isPrivate == true }
        }
        
        // Apply tab filter
        if selectedFilter == .private {
            result = result.filter { $0.isPrivate == true }
        }
        
        // Apply search
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) 
//                $0.genreName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    func filterPrivateAlbums(_ showOnlyPrivate: Bool) {
        showOnlyPrivateAlbums = showOnlyPrivate
    }
    
    func getAlbumsMy() {
        isLoading = true
    
        Task {
            do {
                let fetchedAlbums = try await networkManager.getAlbumsMy()
                albums = fetchedAlbums
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func deleteAlbum(slug: String) {
        isLoading = true
    
        Task {
            do {
                try await networkManager.deleteAlbumsMy(slug: slug)
                getAlbumsMy()
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func loadAlbumsData() {
        // Implement if needed
    }
    
    func togglePrivacy(album: AlbumMy) {
        isLoading = true
        
        Task {
            do {
                let empty = try await networkManager.patchAlbumBySlugMy(slug: album.slug, isPrivate: !album.isPrivate)
                getAlbumsMy()
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func searchAlbums() {
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
