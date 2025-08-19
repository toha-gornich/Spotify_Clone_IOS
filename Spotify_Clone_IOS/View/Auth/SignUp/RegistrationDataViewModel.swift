//
//  RegistrationDataViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 05.08.2025.
//

import SwiftUI

class RegistrationData: ObservableObject {
    var user = RegUser.empty
    var userResponse: RegUserResponse = RegUserResponse.empty
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var username: String = ""
    
    @Published var marketingConsent: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var alertItem: AlertItem?
    @Published var registrationSuccess: Bool = false 
    
    private let networkManager = NetworkManager.shared
    
    // Validation
    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var doPasswordsMatch: Bool {
        password == confirmPassword
    }
    
    var isUsernameValid: Bool {
        username.count >= 3
    }
    
    // Convert to dictionary for POST request
    func toDictionary() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return [
            "email": email,
            "password": password,
            "username": username,
        ]
    }
    
    @MainActor
    func registerUser() async -> Bool {
        isLoading = true
        registrationSuccess = false
        
        do {
            let response = try await NetworkManager.shared.postRegUser(regUser: createUser())
            
            self.userResponse = response
            self.isLoading = false
            self.registrationSuccess = true
            print("Registration successful: \(String(describing: response))")
            return true
            
        } catch {
            self.handleError(error)
            self.isLoading = false
            self.registrationSuccess = false
            return false
        }
    }
    
    func createUser() -> RegUser {
        return RegUser(
            email: email,
            displayName: username,
            password: password,
            rePassword: confirmPassword
        )
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
}
