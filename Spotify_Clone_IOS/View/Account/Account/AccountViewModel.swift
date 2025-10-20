//
//  AccountViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//
import Foundation
import SwiftUI



struct CountryData {
    let name: String
    let code: String
}


@MainActor final class AccountViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var user = UserMy.empty()
    @Published var selectedImage: UIImage?
    @Published var email = ""
    @Published var displayName = ""
    @Published var selectedGender = ""
    @Published var selectedCountry = ""
    @Published var password = ""
    @Published var showGenderPicker = false
    @Published var showCountryPicker = false
    @Published var isLoading: Bool = false
    @Published var showImagePicker = false
    @Published var isDeletingAccount = false
    @Published var showGreeting = false
    @Published var successfullyDeleteAccount = false
    
    private let userService: UserServiceProtocol
    init(userService: UserServiceProtocol = NetworkManager.shared){
        self.userService = userService
    }
    
    let genders = ["Male", "Female", "Other"]
    
    
    lazy var countries: [CountryData] = {
        let englishLocale = Locale(identifier: "en_US")
        
        if #available(iOS 16.0, *) {
            return Locale.Region.isoRegions
                .filter { $0.identifier.count == 2 }
                .compactMap { region in
                    guard let name = englishLocale.localizedString(forRegionCode: region.identifier) else { return nil }
                    return CountryData(name: name, code: region.identifier)
                }
                .sorted { $0.name < $1.name }
        } else {
            return Locale.isoRegionCodes
                .filter { $0.count == 2 }
                .compactMap { code in
                    guard let name = englishLocale.localizedString(forRegionCode: code) else { return nil }
                    return CountryData(name: name, code: code)
                }
                .sorted { $0.name < $1.name }
        }
    }()
        
    
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
        withAnimation(.easeInOut(duration: 0.1)) {
                isLoading = true
            }
        
        Task {
            do {
                
                var imageData: Data? = nil
                if let selectedImage = selectedImage {
                    imageData = selectedImage.jpegData(compressionQuality: 0.8)
                }
                
                
                let updateUser = UpdateUserMe(
                    id: user.id,
                    email: email,
                    displayName: displayName,
                    gender: selectedGender.lowercased(),
                    country: getCountryCode(for: selectedCountry),
                    image: user.image
                )
                
                
                let fetchedUser = try await userService.putUserMe(user: updateUser, imageData: imageData)
                
                
                user = fetchedUser
                
                selectedImage = nil
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func deleteAccount() {
        withAnimation(.easeInOut(duration: 0.1)) {
            isDeletingAccount = true
        }
        
        Task {
            do {
                try await userService.deleteUserMe(password: password)
                
                withAnimation(.easeInOut(duration: 0.1)) {
                    isDeletingAccount = false
                }
                
                successfullyDeleteAccount = true
                logOut()
    
                
            } catch {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isDeletingAccount = false
                }
                handleError(error)
            }
        }
    }

    func getUserMe() {
        isLoading = true
    
        Task {
            do {
                let fetchedUser = try await userService.getProfileMy()
                user = fetchedUser
                email = user.email
                displayName = user.displayName ?? ""
                selectedGender = user.gender ?? ""
                selectedCountry = getCountryName(for: user.country!)
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
                
            }
        }
    }
    
    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var isDisplayNameValid: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var canDeleteAccount: Bool {
        !password.isEmpty
    }
    
    func logOut() {
        // clear auth token
        UserDefaults.standard.removeObject(forKey: "auth_token")
        
        // Clear cache URLs
        URLCache.shared.removeAllCachedResponses()
    }
    
    var canUpdateProfile: Bool {
        let hasDisplayNameChange = displayName != user.displayName
        let hasEmailChange = email != user.email
        let hasGenderChange = selectedGender.lowercased() != user.gender?.lowercased()
        
        // We compare country codes, not names
        let selectedCountryCode = getCountryCode(for: selectedCountry)
        let hasCountryChange = selectedCountryCode != user.country
        
        let hasImageChange = selectedImage != nil
        
        return (hasDisplayNameChange || hasEmailChange || hasGenderChange || hasCountryChange || hasImageChange) && !isLoading
    }

    private func getCountryCode(for countryName: String) -> String {
        return countries.first { $0.name == countryName }?.code ?? countryName
    }

    private func getCountryName(for countryCode: String) -> String {
        return countries.first { $0.code == countryCode }?.name ?? countryCode
    }
    
    
    func loadUserData() {
        email = user.email
        displayName = user.displayName ?? ""
        selectedGender = user.gender ?? ""
        selectedCountry = user.country ?? ""
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
