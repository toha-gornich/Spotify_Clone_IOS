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
    @Published var email = "user1@gmail.com"
    @Published var displayName = "Mafan"
    @Published var selectedGender = "Male"
    @Published var selectedCountry = "Ukraine"
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
        // TODO: Implement profile update logic
        // This could include API calls, validation, etc.
        print("Updating profile with:")
        print("Email: \(email)")
        print("Display Name: \(displayName)")
        print("Gender: \(selectedGender)")
        print("Country: \(selectedCountry)")
    }
    
    func deleteAccount() {
        // TODO: Implement account deletion logic
        // This should include password validation, API calls, etc.
        guard !password.isEmpty else {
            print("Password is required for account deletion")
            return
        }
        
        print("Attempting to delete account with password verification")
        // Here you would typically:
        // 1. Validate the password
        // 2. Make API call to delete account
        // 3. Handle success/error responses
        // 4. Navigate away from the account screen
    }

    func getUserMe() {
        isLoading = true
    
        Task {
            do {
                let fetchedUser = try await networkManager.getUserMe()
                user = fetchedUser
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
