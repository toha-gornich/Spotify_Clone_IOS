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
final class EditTrackViewModel: ObservableObject {
    
    @Published var selectedImage: UIImage?
    @Published var trackTitle: String = ""
    @Published var selectedAlbum: AlbumMy?
    @Published var selectedGenre: Genre?
    @Published var selectedLicense: License?
    @Published var selectedAudioFile: URL?
    @Published var selectedImageFile: URL?
    @Published var releaseDate: Date = Date()
    @Published var isPrivate: Bool = false
    @Published var track: TracksMyBySlug = TracksMyBySlug.empty()


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
    
    private let editTrackManager:CreateTrackServiceProtocol
    
    init(editTrackManager:CreateTrackServiceProtocol = NetworkManager.shared) {
        self.editTrackManager = editTrackManager
        
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

    
    
    func loadAlbums() {
        isLoading = true
        
        Task {
            do {
                albums = try await editTrackManager.getAlbumsMy()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
        
    }
    func getTrackBySlug(slug: String) {
        isLoading = true
        
        Task {
            do {
                
                async let trackData = editTrackManager.getTrackMyBySlug(slug: slug)
                async let albumsData = editTrackManager.getAlbumsMy()
                async let genresData = editTrackManager.getGenres()
                async let licensesData = editTrackManager.getLicenses()
                
                
                let results = try await (trackData, albumsData, genresData, licensesData)
                
                track = results.0
                albums = results.1
                genres = results.2
                licenses = results.3
                
                
                populateFormWithTrack()
                
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func populateFormWithTrack() {
        trackTitle = track.title
        isPrivate = track.isPrivate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: track.releaseDate) {
            releaseDate = date
        }
        

        selectedAlbum = albums.first(where: { $0.id == track.album })
        selectedGenre = genres.first(where: { $0.id == track.genre })
        selectedLicense = licenses.first(where: { $0.id == track.license })
    }

    
    func editTrack(completion: @escaping (Bool) -> Void) {
        guard canUpdateTrack else {
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                
                var audioData: Data? = nil
                if let audioFileURL = selectedAudioFile {
                    audioData = try? Data(contentsOf: audioFileURL)
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let releaseDateString = dateFormatter.string(from: releaseDate)
                
                
                _ = try await NetworkManager.shared.patchTrackMyBySlug(
                    slug: track.slug,
                    title: trackTitle != track.title ? trackTitle : nil,
                    albumId: selectedAlbum?.id != track.album ? selectedAlbum?.id : nil,
                    genreId: selectedGenre?.id != track.genre ? selectedGenre?.id : nil,
                    licenseId: selectedLicense?.id != track.license ? selectedLicense?.id : nil,
                    releaseDate: releaseDateString != track.releaseDate ? releaseDateString : nil,
                    isPrivate: isPrivate != track.isPrivate ? isPrivate : nil,
                    imageData: imageData,
                    audioData: audioData
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
  
    func loadGenres() {
        isLoading = true
        
        Task {
            do {
                genres = try await editTrackManager.getGenres()
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
                licenses = try await editTrackManager.getLicenses()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    
    var canUpdateTrack: Bool {
        let hasTitleChange = trackTitle != track.title
        let hasAlbumChange = selectedAlbum?.id != track.album
        let hasGenreChange = selectedGenre?.id != track.genre
        let hasLicenseChange = selectedLicense?.id != track.license
        let hasImageChange = selectedImage != nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentReleaseDateString = dateFormatter.string(from: releaseDate)
        let hasReleaseDateChange = currentReleaseDateString != track.releaseDate
        
        let hasPrivacyChange = isPrivate != track.isPrivate
        
        return (hasTitleChange || hasAlbumChange || hasGenreChange ||
                hasLicenseChange || hasImageChange ||
                hasReleaseDateChange || hasPrivacyChange) && !isLoading
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
