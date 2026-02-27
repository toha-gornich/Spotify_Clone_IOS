//
//  RootView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 27.02.2026.
//

import SwiftUI

struct RootView: View {
    @StateObject private var appVM = AppViewModel()
    @StateObject private var mainVM = MainViewModel()
    @StateObject private var playerManager = AudioPlayerManager()
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        ZStack {
            contentView
                .environmentObject(appVM)
                .environmentObject(mainVM)
                .environmentObject(playerManager)
                .onOpenURL { appVM.handleDeepLink(url: $0) }
                .alert("Activation", isPresented: $appVM.showActivationAlert) {
                    Button("OK") { }
                } message: {
                    Text(appVM.activationMessage)
                }
                // MiniPlayer прямо тут
                .overlay(alignment: .bottom) {
                    if playerManager.sheetState == .mini,
                       playerManager.currentTrack != nil {
                        MiniPlayerView(playerManager: playerManager)
                            .padding(.horizontal, 8)
                            .padding(.bottom, keyboardHeight > 0 ? 8 : 50)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.25), value: keyboardHeight)
                    }
                }
                .sheet(isPresented: .constant(playerManager.sheetState == .full)) {
                    FullPlayerView(playerManager: playerManager)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    keyboardHeight = frame?.height ?? 0
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    keyboardHeight = 0
                }

            SideMenuView(isShowing: $mainVM.isShowMenu)
                .environmentObject(mainVM)
                .environmentObject(playerManager)
                .zIndex(1000)
        }
        .task {
            await appVM.verifyToken()
        }
        .onReceive(NotificationCenter.default.publisher(for: .userDidLogin)) { _ in
            appVM.handleLogin()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch appVM.appState {
        case .loading:
            ProgressView("Loading...")
        case .unauthenticated:
            GreetingView()
        case .authenticated:
            MainView()
        }
    }
}


#Preview {
    RootView()
}
