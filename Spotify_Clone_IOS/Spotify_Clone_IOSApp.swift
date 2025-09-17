//
//  Spotify_Clone_IOSApp.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.05.2025.
//

import SwiftUI
@main
struct Spotify_Clone_IOSApp: App {
    private let networkManager = NetworkManager.shared
    @State private var isTokenValid = false
    @State private var isLoading = true
    @State private var showActivationAlert = false
    @State private var activationMessage = ""
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    if isLoading {
                        ProgressView("Loading...")
                    } else if isTokenValid {
//                        GreetingView()
                         MainView()
                    } else {
//                        MainView()
                        GreetingView()
                    }
                }
                .onAppear {
                    verifyToken()
                }
                .onOpenURL { url in
                    handleDeepLink(url: url)
                }
                .alert("Activation", isPresented: $showActivationAlert) {
                    Button("OK") { }
                } message: {
                    Text(activationMessage)
                }
            }
        }
    }
    
    private func verifyToken() {
        let token = UserDefaults.standard.string(forKey: "auth_token")
        
        Task {
            if token?.isEmpty != false {
                await MainActor.run {
                    isTokenValid = false
                    isLoading = false
                }
                return
            }
            
            do {
                try await networkManager.postVerifyToken(tokenVerifyRequest: TokenVerifyRequest(token: token!))
                await MainActor.run {
                    isTokenValid = true
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isTokenValid = false
                    isLoading = false
                }
            }
        }
    }
    
    private func handleDeepLink(url: URL) {
        
        if url.scheme == "com.cl.appauth" && url.path.contains("/account/auth/activate/") {

            let pathComponents = url.pathComponents
            if let uidIndex = pathComponents.firstIndex(of: "activate"),
               uidIndex + 1 < pathComponents.count {
                
                let uid = pathComponents[uidIndex + 1]
                let token = url.lastPathComponent
                
                print("uid  " + uid)
                print("token  " + token)
                activateAccount(uid: uid, token: token)
            }
        }
    }
    
    private func activateAccount(uid: String, token: String) {
        Task {
            do {
                
                let activationRequest = AccountActivationRequest(uid: uid, token: token)
                try await networkManager.postActivateAccount(activationRequest: activationRequest)
                
                await MainActor.run {
                    activationMessage = "Обліковий запис успішно активовано!"
                    showActivationAlert = true
                    verifyToken()
                }
            } catch {
                await MainActor.run {
                    activationMessage = "Помилка активації: \(error.localizedDescription)"
                    showActivationAlert = true
                }
            }
        }
    }
}

struct AccountActivationRequest: Codable {
    let uid: String
    let token: String
}
