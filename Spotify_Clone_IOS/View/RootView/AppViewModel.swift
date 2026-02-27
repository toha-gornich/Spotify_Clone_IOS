//
//  AppViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 27.02.2026.
//

import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published var appState: AppState = .loading
    @Published var showActivationAlert = false
    @Published var activationMessage = ""
    
    enum AppState {
        case loading
        case authenticated
        case unauthenticated
    }
    
    private let networkManager = NetworkManager.shared
    private let keychainManager = KeychainManager.shared
    
    func verifyToken() async {
        guard let tokenData = keychainManager.read(key: .accessToken),
              let token = String(data: tokenData, encoding: .utf8)
        else {
            appState = .unauthenticated
            return
        }
        
        do {
            try await networkManager.postVerifyToken(tokenVerifyRequest: TokenVerifyRequest(token: token))
            appState = .authenticated
        } catch {
            appState = .unauthenticated
        }
    }
    
    func handleLogin() {
        appState = .authenticated
    }
    
    func handleLogout() {
        keychainManager.delete(key: KeychainKey.accessToken.rawValue)
        appState = .unauthenticated
    }
    
    // Parses incoming deep link URL and triggers account activation
    func handleDeepLink(url: URL) {
        guard url.scheme == "com.cl.appauth",
              url.path.contains("/account/auth/activate/"),
              let uidIndex = url.pathComponents.firstIndex(of: "activate"),
              uidIndex + 1 < url.pathComponents.count
        else { return }
        
        let uid = url.pathComponents[uidIndex + 1]
        let token = url.lastPathComponent
        Task { await activateAccount(uid: uid, token: token) }
    }
    
    // Sends activation request and re-verifies token on success
    private func activateAccount(uid: String, token: String) async {
        do {
            try await networkManager.postActivateAccount(
                activationRequest: AccountActivationRequest(uid: uid, token: token)
            )
            activationMessage = "Account successfully activated!"
            showActivationAlert = true
            await verifyToken()
        } catch {
            activationMessage = "Activation error: \(error.localizedDescription)"
            showActivationAlert = true
        }
    }
}

