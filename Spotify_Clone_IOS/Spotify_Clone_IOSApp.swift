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
    @StateObject private var playerManager = AudioPlayerManager()
    @StateObject private var mainVM = MainViewModel()
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
                        MainView()
                    } else {
                        GreetingView()
                    }
                }
                .environmentObject(playerManager)
                .environmentObject(mainVM)
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
            .environmentObject(playerManager)
            .environmentObject(mainVM)
            .overlay(
                Group {
                    if playerManager.sheetState == .mini {
                        VStack {
                            Spacer()
                            
                            MiniPlayerView(playerManager: playerManager)
                                .padding(.bottom, mainVM.isTabBarVisible ? 45 : 0)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .animation(.easeInOut(duration: 0.3), value: playerManager.sheetState)
                        }
                        .allowsHitTesting(true)
                    }
                },
                alignment: .bottom
            )
            .sheet(isPresented: .constant(playerManager.sheetState == .full)) {
                FullPlayerView(playerManager: playerManager)
                    .environmentObject(playerManager)
                    .environmentObject(mainVM)
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
                    activationMessage = "Account successfully activated!"
                    showActivationAlert = true
                    verifyToken()
                }
            } catch {
                await MainActor.run {
                    activationMessage = "Activation error: \(error.localizedDescription)"
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
