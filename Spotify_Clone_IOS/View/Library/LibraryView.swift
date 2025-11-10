//
//  LibraryView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct LibraryView: View {
    @State private var showCreatePlaylist = false
    @StateObject private var libraryVM = LibraryViewModel()
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Image(systemName: "square.stack.3d.up")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryText)
                    
                    Text("Your Library")
                        .font(.customFont(.bold, fontSize: 22))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    

                    Button {
                        showCreatePlaylist = true
                        libraryVM.createPlaylist()
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryText)
                    }
                    .navigationDestination(isPresented: $showCreatePlaylist) {
                        MyPlaylistView(slugPlaylist: libraryVM.playlist.slug)
                            .environmentObject(playerManager)
                            .environmentObject(mainVM)
                    }
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                
                // Tab Selector
                HStack(spacing: 15) {
                    TabButtonLibrary(title: "Playlists", isSelected: libraryVM.selectedTab == 0) {
                        libraryVM.selectedTab = 0
                    }
                    
                    TabButtonLibrary(title: "Artists", isSelected: libraryVM.selectedTab == 1) {
                        libraryVM.selectedTab = 1
                    }
                    
                    TabButtonLibrary(title: "Albums", isSelected: libraryVM.selectedTab == 2) {
                        libraryVM.selectedTab = 2
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if libraryVM.selectedTab == 0 {
                            PlaylistsContent(playlists: libraryVM.playlists)
                                .environmentObject(playerManager)
                                .environmentObject(mainVM)
                                .environmentObject(libraryVM) 
                        } else if libraryVM.selectedTab == 1 {
                            ArtistsContent(artists: libraryVM.artists)
                                .environmentObject(playerManager)
                                .environmentObject(mainVM)
                        } else {
                            AlbumsContent(albums: libraryVM.albums)
                                .environmentObject(playerManager)
                                .environmentObject(mainVM)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            
            if libraryVM.isLoading {
                LoadingView()
            }
        }
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .alert(item: $libraryVM.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
        .task {
            libraryVM.loadLibraryData()
        }
        .onAppear {
            mainVM.isTabBarVisible = true
            libraryVM.getUserMe()
        }
    }
}
