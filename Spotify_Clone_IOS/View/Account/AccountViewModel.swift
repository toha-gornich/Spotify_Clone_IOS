//
//  AccountViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//
import Foundation
import SwiftUI


@MainActor final class AccountViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var user = UserMe.empty()
    @Published var email = ""
    @Published var displayName = ""
    @Published var selectedGender = ""
    @Published var selectedCountry = ""
    @Published var password = ""
    @Published var showGenderPicker = false
    @Published var showCountryPicker = false
    @Published var isLoading: Bool = false
    
    private let networkManager = NetworkManager.shared
    
    let genders = ["Male", "Female", "Other"]
    let countries = ["Ukraine", "United States", "Canada", "United Kingdom", "Germany", "France", "Other"]
    
    
    func showGenderSheet() {
        showGenderPicker = true
    }
    
    func hideGenderSheet() {
        showGenderPicker = false
    }
    
    func showCountrySheet() {
        showCountryPicker = true
    }
    
    func hideCountrySheet() {
        showCountryPicker = false
    }
    
    func selectGender(_ gender: String) {
        selectedGender = gender
    }
    
    func selectCountry(_ country: String) {
        selectedCountry = country
    }
    
    func updateProfile() {
        user = UserMe(id: user.id, email: email, displayName: displayName, gender: selectedGender, country: selectedCountry, image: user.image, color: user.color, typeProfile: user.typeProfile, artistSlug: user.artistSlug, isPremium: user.isPremium, followersCount: user.followersCount, followingCount: user.followingCount, playlistsCount: user.playlistsCount)
        
        let updateUser = UpdateUserMe(id: user.id, email: email, displayName: displayName, gender: selectedGender, country: selectedCountry, image: user.image)
        
        isLoading = true
    
        Task {
            do {
                let fetchedUser = try await networkManager.putUserMe(user: updateUser)
                print(fetchedUser.displayName)
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }

    }
    
    func deleteAccount() {
        guard !password.isEmpty else {
            print("Password is required for account deletion")
            return
        }
        

    }

    func getUserMe() {
        isLoading = true
    
        Task {
            do {
                let fetchedUser = try await networkManager.getUserMe()
                user = fetchedUser
                email = user.email
                displayName = user.displayName ?? ""
                selectedGender = user.gender ?? ""
                selectedCountry = user.country!.countryName() ?? "Not specified"
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
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
    
    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var isDisplayNameValid: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var canUpdateProfile: Bool {
        isEmailValid && isDisplayNameValid
    }
    
    var canDeleteAccount: Bool {
        !password.isEmpty
    }
    
    
}
