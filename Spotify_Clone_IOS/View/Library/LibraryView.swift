//
//  LibraryView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct LibraryView: View {
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
                        print("Add new item")
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryText)
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
        }
    }
}

// MARK: - Tab Button
struct TabButtonLibrary: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.customFont(.medium, fontSize: 14))
                .foregroundColor(isSelected ? .primaryText : .secondaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected ? Color.primaryText.opacity(0.15) : Color.clear
                )
                .cornerRadius(16)
        }
    }
}

// MARK: - Playlists Content
struct PlaylistsContent: View {
    let playlists: [Playlist]
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(playlists, id: \.slug) { playlist in
                NavigationLink(destination: PlaylistView(slugPlaylist: playlist.slug)
                    .environmentObject(mainVM)
                    .environmentObject(playerManager)) {
                    LibraryItemRow(
                        imageURL: playlist.image,
                        title: playlist.title,
                        subtitle: playlist.user.displayName
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Artists Content
struct ArtistsContent: View {
    let artists: [ArtistTrack]
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(artists, id: \.slug) { artist in
                NavigationLink(destination: ArtistView(slugArtist: artist.slug)
                    .environmentObject(mainVM)
                    .environmentObject(playerManager)) {
                    LibraryItemRow(
                        imageURL: artist.image,
                        title: artist.displayName,
                        subtitle: "Artist"
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Albums Content
struct AlbumsContent: View {
    let albums: [Album]
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(albums, id: \.slug) { album in
                NavigationLink(destination: AlbumView(slugAlbum: album.slug)
                    .environmentObject(mainVM)
                    .environmentObject(playerManager)) {
                    LibraryItemRow(
                        imageURL: album.image,
                        title: album.title,
                        subtitle: album.artist.displayName
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}


// MARK: - Library Item Row
struct LibraryItemRow: View {
    let imageURL: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 56, height: 56)
            .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.customFont(.medium, fontSize: 16))
                    .foregroundColor(.primaryText)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.customFont(.regular, fontSize: 14))
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
