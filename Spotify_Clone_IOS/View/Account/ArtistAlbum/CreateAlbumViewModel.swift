//
//  CreateTrackViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.09.2025.
//

import UIKit
import Combine

@MainActor
final class CreateAlbumViewModel: ObservableObject {
    
    
    @Published var albumTitle: String = ""
    @Published var albumDescription: String = ""
    @Published var selectedImage: UIImage?
    @Published var selectedImageFile: URL?
    @Published var selectedGenre: Genre?
    @Published var releaseDate: Date = Date()
    @Published var isPrivate: Bool = false
    
    
    @Published var genres: [Genre] = []
    
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showImagePicker = false
    @Published var alertItem: AlertItem?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager = NetworkManager.shared
    
    
    var isFormValid: Bool {
        return !albumTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !albumDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var imageFileName: String {
        if let url = selectedImageFile {
            return url.lastPathComponent
        }
        return "No image selected"
    }
    
    
    init() {
        loadInitialData()
    }
    
    
    
    func loadInitialData() {
        loadGenres()
    }
    
    func loadGenres() {
        isLoading = true
        
        Task {
            do {
                genres = try await networkManager.getGenres()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    
    func createAlbum(completion: @escaping (Bool) -> Void) {
        guard isFormValid else { return }
        
        isLoading = true
        
        Task {
            do {
                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let releaseDateString = dateFormatter.string(from: releaseDate)
                
                _ = try await networkManager.postCreateAlbum(
                    title: albumTitle,
                    description: albumDescription,

                    releaseDate: releaseDateString,
                    isPrivate: isPrivate,
                    imageData: imageData
                )
                
                await MainActor.run {
                    isLoading = false
                    showSuccessAlert = true
                    completion(true)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Form Management
    
    func resetForm() {
        albumTitle = ""
        albumDescription = ""
        selectedImage = nil
        selectedImageFile = nil
        selectedGenre = nil
        releaseDate = Date()
        isPrivate = false
    }
    
    // MARK: - Validation
    
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
