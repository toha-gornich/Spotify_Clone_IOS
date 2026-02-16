//
//  MainView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI
struct MainView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var genresVM = GenresViewModel()
    @StateObject private var libraryVM = LibraryViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $mainVM.selectTab) {
                HomeView(homeVM: homeVM)
                    .tag(0)
                
                GenresView()
                    .environmentObject(genresVM)
                    .tag(1)
                
                LibraryView()
                    .environmentObject(libraryVM)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            // Custom tab bar
            VStack {
                Spacer()
                
                if mainVM.isTabBarVisible {
                    HStack {
                        Spacer()
                        
                        TabButton(title: "Home", icon: "home_tab_f", iconUnfocus: "home_tab", isSelect: mainVM.selectTab == 0) {
                            mainVM.selectTab = 0
                        }
                        
                        Spacer()
                        
                        TabButton(title: "Search", icon: "search_tab_f", iconUnfocus: "search_tab", isSelect: mainVM.selectTab == 1) {
                            mainVM.selectTab = 1
                        }
                        
                        Spacer()
                        
                        TabButton(title: "Library", icon: "library_tab_f", iconUnfocus: "library_tab", isSelect: mainVM.selectTab == 2) {
                            mainVM.selectTab = 2
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, .bottomInsets)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.bg.opacity(0.6),
                                Color.bg.opacity(0.8),
                                Color.bg.opacity(1),
                                Color.bg
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(radius: 2)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .zIndex(2)
            
            SideMenuView(isShowing: $mainVM.isShowMenu)
                .environmentObject(mainVM)
                .environmentObject(playerManager)
                .zIndex(3)
        }
        .environmentObject(mainVM)
        .environmentObject(playerManager)
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .onAppear {
            homeVM.loadAllDataIfNeeded()
        }
    }
}
