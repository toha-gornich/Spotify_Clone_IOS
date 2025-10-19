//
//  CreateTrackViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.09.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class EditAlbumViewModel: ObservableObject {
    
    
    @Published var selectedImage: UIImage?
    @Published var albumTitle: String = ""
    @Published var albumDescription: String = ""
    @Published var selectedImageFile: URL?
    @Published var releaseDate: Date = Date()
    @Published var isPrivate: Bool = false
    @Published var album: Album = Album.empty
    
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showImagePicker = false
    @Published var alertItem: AlertItem?
    
    private var cancellables = Set<AnyCancellable>()
    private let editAlbumService: EditAlbumServiceProtocol
    
    init(editAlbumService:EditAlbumServiceProtocol = NetworkManager.shared){
        self.editAlbumService = editAlbumService
    }
    

    
    
    var imageFileName: String {
        if let url = selectedImageFile {
            return url.lastPathComponent
        }
        return "No image selected"
    }
    
    var canUpdateAlbum: Bool {
        let hasTitleChange = albumTitle != album.title
        let hasDescriptionChange = albumDescription != album.description
        let hasImageChange = selectedImage != nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentReleaseDateString = dateFormatter.string(from: releaseDate)
        let hasReleaseDateChange = currentReleaseDateString != album.releaseDate
        
        let hasPrivacyChange = isPrivate != album.isPrivate
        
        return (hasTitleChange || hasDescriptionChange || hasImageChange ||
                hasReleaseDateChange || hasPrivacyChange) && !isLoading
    }
    
    
    
    
    func getAlbumBySlug(slug: String) {
        isLoading = true
        
        Task {
            do {
                album = try await editAlbumService.getAlbumBySlug(slug: slug)
                populateFormWithAlbum()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func populateFormWithAlbum() {
        albumTitle = album.title
        albumDescription = album.description
        isPrivate = album.isPrivate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: album.releaseDate) {
            releaseDate = date
        }
    }
    
    
    func editAlbum(completion: @escaping (Bool) -> Void) {
        guard canUpdateAlbum else {
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let releaseDateString = dateFormatter.string(from: releaseDate)
                
                _ = try await editAlbumService.patchAlbumBySlugMy(
                    slug: album.slug,
                    title: albumTitle != album.title ? albumTitle : nil,
                    description: albumDescription != album.description ? albumDescription : nil,
                    releaseDate: releaseDateString != album.releaseDate ? releaseDateString : nil,
                    isPrivate: isPrivate != album.isPrivate ? isPrivate : nil,
                    imageData: imageData
                )
                
                
                isLoading = false
                showSuccessAlert = true
                completion(true)
                
            } catch {
                
                isLoading = false
                errorMessage = error.localizedDescription
                showErrorAlert = true
                completion(false)
                
            }
        }
    }
    
    
    
    func resetForm() {
        albumTitle = ""
        albumDescription = ""
        selectedImage = nil
        selectedImageFile = nil
        releaseDate = Date()
        isPrivate = false
    }
    
    
    func validateAlbumTitle() -> String? {
        let trimmed = albumTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "Album title is required"
        }
        if trimmed.count < 2 {
            return "Album title must be at least 2 characters"
        }
        if trimmed.count > 100 {
            return "Album title must be less than 100 characters"
        }
        return nil
    }
    
    func validateDescription() -> String? {
        let trimmed = albumDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "Description is required"
        }
        if trimmed.count < 10 {
            return "Description must be at least 10 characters"
        }
        if trimmed.count > 500 {
            return "Description must be less than 500 characters"
        }
        return nil
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
