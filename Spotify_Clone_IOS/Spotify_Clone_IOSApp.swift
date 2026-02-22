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
    @State private var keyboardHeight: CGFloat = 0

    var body: some Scene {
        WindowGroup {
            ZStack {
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
                .onAppear { verifyToken() }
                .onOpenURL { handleDeepLink(url: $0) }
                .alert("Activation", isPresented: $showActivationAlert) {
                    Button("OK") { }
                } message: {
                    Text(activationMessage)
                }
                .overlay(
                    Group {
                        if playerManager.sheetState == .mini, let _ = playerManager.currentTrack {
                            VStack {
                                Spacer()
                                MiniPlayerView(playerManager: playerManager)
                                    .padding(.horizontal, 8)
                                    .padding(.bottom, keyboardHeight > 0 ? 8 : 50)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(.easeInOut(duration: 0.25), value: keyboardHeight)
                            }
                            .allowsHitTesting(true)
                        }
                    },
                    alignment: .bottom
                )
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    keyboardHeight = frame?.height ?? 0
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    keyboardHeight = 0
                }
                .zIndex(100)
                .sheet(isPresented: .constant(playerManager.sheetState == .full)) {
                    FullPlayerView(playerManager: playerManager)
                        .environmentObject(playerManager)
                        .environmentObject(mainVM)
                }

                SideMenuView(isShowing: $mainVM.isShowMenu)
                    .environmentObject(mainVM)
                    .environmentObject(playerManager)
                    .zIndex(1000)
            }
        }
    }

    private func verifyToken() {
        let token = UserDefaults.standard.string(forKey: "auth_token")

        Task {
            guard token?.isEmpty == false else {
                await MainActor.run { isTokenValid = false; isLoading = false }
                return
            }

            do {
                try await networkManager.postVerifyToken(tokenVerifyRequest: TokenVerifyRequest(token: token!))
                await MainActor.run { isTokenValid = true; isLoading = false }
            } catch {
                await MainActor.run { isTokenValid = false; isLoading = false }
            }
        }
    }

    private func handleDeepLink(url: URL) {
        guard url.scheme == "com.cl.appauth",
              url.path.contains("/account/auth/activate/"),
              let uidIndex = url.pathComponents.firstIndex(of: "activate"),
              uidIndex + 1 < url.pathComponents.count
        else { return }

        let uid = url.pathComponents[uidIndex + 1]
        let token = url.lastPathComponent
        activateAccount(uid: uid, token: token)
    }

    private func activateAccount(uid: String, token: String) {
        Task {
            do {
                try await networkManager.postActivateAccount(activationRequest: AccountActivationRequest(uid: uid, token: token))
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
