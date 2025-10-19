//
//  AccountViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//
import Foundation
import SwiftUI

@MainActor final class ArtistProfileViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var artist = Artist.empty
    @Published var selectedImage: UIImage?
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var displayName = ""
    @Published var isLoading: Bool = false
    @Published var showImagePicker = false
    
    private let artistManager: ArtistServiceProtocol
    init(artistManager:ArtistServiceProtocol = NetworkManager.shared) {
        self.artistManager = artistManager
    }
        

    func updateProfile() {
        withAnimation(.easeInOut(duration: 0.1)) {
                isLoading = true
            }
        
        Task {
            do {
                
                var imageData: Data? = nil
                if let selectedImage = selectedImage {
                    imageData = selectedImage.jpegData(compressionQuality: 0.8)
                }
                
                
                let updateArtist = UpdateArtist(
                    id: artist.id, firstName: firstName, lastName: lastName, displayName: displayName, image: artist.image
                )
                
                
                let fetchedArtist = try await artistManager.putArtistMe(artist: updateArtist, imageData: imageData)
                
                
                artist = fetchedArtist
                
                selectedImage = nil
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    

    func getArtistMe() {
        isLoading = true
    
        Task {
            do {
                let fetchedArtist = try await artistManager.getArtistMe()
                artist = fetchedArtist
                firstName = artist.firstName
                lastName = artist.lastName
                displayName = artist.displayName

                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    
    var isDisplayNameValid: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    

    var canUpdateProfile: Bool {
        let hasFirstNameChange = firstName != artist.firstName
        let hasLastNameChange = lastName != artist.lastName
        let hasDisplayNameChange = displayName != artist.displayName
        
        let hasImageChange = selectedImage != nil
        
        return (hasFirstNameChange || hasLastNameChange || hasImageChange || hasDisplayNameChange ) && !isLoading
    }


    func loadUserData() {
        firstName = artist.firstName
        lastName = artist.lastName
        displayName = artist.displayName
        selectedImage = nil
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
