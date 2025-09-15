//
//  AuthViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 17.08.2025.
//

import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var emailOrUsername: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var alertItem: AlertItem?
    @Published var loginSuccess: Bool = false
    

    private let networkManager = NetworkManager.shared
    
    var isLoginEnabled: Bool {
        !emailOrUsername.isEmpty && !password.isEmpty
    }
    
    var isEmailValid: Bool {
        emailOrUsername.contains("@") && emailOrUsername.contains(".")
    }
    
//    // MARK: - Authentication Methods
    func login() async -> Bool {
        guard isLoginEnabled else { return false }
        
        isLoading = true
        errorMessage = nil
        loginSuccess = false
        
        do {
            let loginRequest = createLoginRequest()
            
            let response = try await networkManager.postLogin(loginRequest: loginRequest)
            
            let success = await handleLoginSuccess(response)
            return success
            
        } catch {
            handleLoginError(error)
            return false
        }
    }

    private func createLoginRequest() -> LoginRequest {
        return LoginRequest(
            email: emailOrUsername,
            password: password
        )
    }

    private func handleLoginSuccess(_ response: LoginResponse) async -> Bool {
        isLoading = false
        loginSuccess = true
        
        // Store auth token if needed
        let token = response.access
        let tokenRefresh = response.refresh
        UserDefaults.standard.set(tokenRefresh, forKey: "auth_token")
        
        
        do {
            try await networkManager.postVerifyToken(tokenVerifyRequest: TokenVerifyRequest(token: token))
            print("Token verified successfully")
            return true
        } catch {
            handleLoginError(error)
            return false
        }
    }
    
    
    
    private func handleLoginError(_ error: Error) {
        handleError(error)
    }
    
    private func handleError(_ error: Error) {
        isLoading = false
        
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
        }
    }
    
 
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
}

