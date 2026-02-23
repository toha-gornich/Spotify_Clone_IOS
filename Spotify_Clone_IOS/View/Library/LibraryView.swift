//
//  LibraryView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var router: Router
    @State private var showCreatePlaylist = false
    @ObservedObject var libraryVM: LibraryViewModel
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
                        libraryVM.createPlaylist()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryText)
                    }
                    .onChange(of: libraryVM.playlist.slug) { slug in
                        if !slug.isEmpty {
                            router.navigateTo(AppRoute.myPlaylist(slugPlaylist: slug))
                        }
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
                            if libraryVM.playlists.isEmpty && !libraryVM.isLoading {
                                EmptyLibraryView(
                                    icon: "music.note.list",
                                    title: "No playlists yet",
                                    subtitle: "Create your first playlist",
                                    actionTitle: "Create Playlist",
                                    action: {
                                        showCreatePlaylist = true
                                        libraryVM.createPlaylist()
                                    }
                                ).padding(.top, 50)
                            } else {
                                PlaylistsContent(libraryVM: libraryVM)

                            }
                        } else if libraryVM.selectedTab == 1 {
                            if libraryVM.artists.isEmpty && !libraryVM.isLoading {
                                EmptyLibraryView(
                                    icon: "person.2",
                                    title: "No artists yet",
                                    subtitle: "Follow artists to see them here"
                                ).padding(.top, 50)
                            } else {
                                ArtistsContent(artists: libraryVM.artists)
                            }
                        } else {
                            if libraryVM.albums.isEmpty && !libraryVM.isLoading {
                                EmptyLibraryView(
                                    icon: "square.stack",
                                    title: "No albums yet",
                                    subtitle: "Save albums to see them here"
                                ).padding(.top, 50)
                            } else {
                                AlbumsContent(albums: libraryVM.albums)
                            }
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
            libraryVM.getUserMe()
        }
    }
}


