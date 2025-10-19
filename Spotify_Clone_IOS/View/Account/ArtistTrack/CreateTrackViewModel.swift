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
final class CreateTrackViewModel: ObservableObject {
    
    
    @Published var selectedImage: UIImage?
    @Published var trackTitle: String = ""
    @Published var selectedAlbum: AlbumMy?
    @Published var selectedGenre: Genre?
    @Published var selectedLicense: License?
    @Published var selectedAudioFile: URL?
    @Published var selectedImageFile: URL?
    @Published var releaseDate: Date = Date()
    @Published var isPrivate: Bool = false
    
    
    @Published var albums: [AlbumMy] = []
    @Published var genres: [Genre] = []
    @Published var licenses: [License] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showImagePicker = false
    @Published var showAudioPicker = false
    
    @Published var alertItem: AlertItem?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let createTrackManager:CreateTrackServiceProtocol
    
    init(createTrackManager:CreateTrackServiceProtocol = NetworkManager.shared) {
        self.createTrackManager = createTrackManager
        loadInitialData()
    }
    
    var isFormValid: Bool {
        return !trackTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               selectedAlbum != nil &&
               selectedGenre != nil &&
               selectedLicense != nil &&
               selectedAudioFile != nil
    }
    
    var audioFileName: String {
        if let url = selectedAudioFile {
            return url.lastPathComponent
        }
        return "Виберіть файл"
    }
    
    var imageFileName: String {
        if let url = selectedImageFile {
            return url.lastPathComponent
        }
        return "No image selected"
    }
    
    

    
    
    func loadInitialData() {
        loadAlbums()
        loadGenres()
        loadLicenses()
    }
    
    
    func loadAlbums() {
        isLoading = true
        
        Task {
            do {
                albums = try await createTrackManager.getAlbumsMy()
                print(albums[0].description)
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    
    func loadGenres() {
        isLoading = true
        
        Task {
            do {
                genres = try await createTrackManager.getGenres()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    
    func loadLicenses() {
        isLoading = true
        
        Task {
            do {
                licenses = try await createTrackManager.getLicenses()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func createTrack(completion: @escaping (Bool) -> Void) {
        guard isFormValid else { return }
        
        isLoading = true
        
        Task {
            do {
                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                let audioData = try? Data(contentsOf: selectedAudioFile!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let releaseDateString = dateFormatter.string(from: releaseDate)
                
                _ = try await NetworkManager.shared.postCreateTrack(
                    title: trackTitle,
                    albumId: selectedAlbum!.id,
                    genreId: selectedGenre!.id,
                    licenseId: selectedLicense!.id,
                    releaseDate: releaseDateString,
                    isPrivate: isPrivate,
                    imageData: imageData,
                    audioData: audioData
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
        trackTitle = ""
        selectedAlbum = nil
        selectedGenre = nil
        selectedLicense = nil
        selectedAudioFile = nil
        selectedImageFile = nil
        releaseDate = Date()
        isPrivate = false
    }
    
    
    func validateTrackTitle() -> String? {
        let trimmed = trackTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "Track title is required"
        }
        if trimmed.count < 2 {
            return "Track title must be at least 2 characters"
        }
        if trimmed.count > 100 {
            return "Track title must be less than 100 characters"
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
