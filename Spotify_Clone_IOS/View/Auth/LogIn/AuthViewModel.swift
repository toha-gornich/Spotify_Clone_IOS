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
    @Published var alertItem: AlertItem?

    private let authManager: AuthServiceProtocol
    private let keychainManager = KeychainManager.shared

    init(authManager: AuthServiceProtocol = NetworkManager.shared) {
        self.authManager = authManager
    }

    // MARK: - Computed Properties

    var isLoginEnabled: Bool {
        !emailOrUsername.isEmpty && !password.isEmpty
    }

    var isEmailValid: Bool {
        emailOrUsername.contains("@") && emailOrUsername.contains(".")
    }

    // MARK: - Actions

    func login() async -> Bool {
        guard isLoginEnabled else { return false }

        isLoading = true

        do {
            let request = LoginRequest(email: emailOrUsername, password: password)
            let response = try await authManager.postLogin(loginRequest: request)
            saveTokens(response)
            isLoading = false
            return true
        } catch {
            handleError(error)
            return false
        }
    }

    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }

    // MARK: - Private

    // Saves access and refresh tokens to Keychain after successful login
    private func saveTokens(_ response: LoginResponse) {
        if let accessData = response.access.data(using: .utf8) {
            keychainManager.save(key: .accessToken, data: accessData)
        }
        if let refreshData = response.refresh.data(using: .utf8) {
            keychainManager.save(key: .refreshToken, data: refreshData)
        }
    }

    private func handleError(_ error: Error) {
        isLoading = false

        guard let apError = error as? APError else { return }

        switch apError {
        case .invalidResponse:  alertItem = AlertContext.invalidResponse
        case .invalidURL:       alertItem = AlertContext.invalidURL
        case .invalidData:      alertItem = AlertContext.invalidData
        case .unableToComplete: alertItem = AlertContext.unableToComplete
        }
    }
}
