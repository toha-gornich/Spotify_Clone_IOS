//
//  HomeView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//


import SwiftUI

struct HomeView: View {
    @State private var greeting = ""
    @ObservedObject var homeVM: HomeViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    Button {
                        mainVM.isShowMenu = true
                    } label: {
                        Image("settings")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                    Text(greeting)
                        .font(.customFont(.bold, fontSize: 18))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    if homeVM.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(0..<min(6, homeVM.tracks.count), id: \.self) { index in
                                if index == 0 {
                                    TrackCell(track: homeVM.tracks[index])
                                        .gridCellColumns(2)
                                } else {
                                    TrackCell(track: homeVM.tracks[index])
                                }
                            }
                        }
                        
                        ViewAllSection(title: "Popular artists") {}
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(homeVM.artists.indices, id: \.self) { index in
                                    let sObj = homeVM.artists[index]
                                    NavigationLink(destination: ArtistView(slugArtist: sObj.slug)) {
                                        ArtistItemView(artist: sObj)
                                    }
                                }
                            }
                        }
                        
                        ViewAllSection(title: "Popular albums") {}
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(homeVM.albums.indices, id: \.self) { index in
                                    let sObj = homeVM.albums[index]
                                    NavigationLink(destination: AlbumView(slugAlbum: sObj.slug)) {
                                        MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                                    }
                                }
                            }
                        }
                        
                        ViewAllSection(title: "Popular playlists") {}
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(homeVM.playlists.indices, id: \.self) { index in
                                    let playlist = homeVM.playlists[index]
                                    NavigationLink(destination: playlistDestination(for: playlist)) {
                                        MediaItemCell(
                                            imageURL: playlist.image,
                                            title: playlist.title,
                                            width: 140,
                                            height: 140
                                        )
                                    }
                                }
                            }
                        }
                        
                        ViewAllSection(title: "Popular tracks") {}
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(homeVM.tracks.indices, id: \.self) { index in
                                    let sObj = homeVM.tracks[index]
                                    NavigationLink(destination: TrackView(slugTrack: sObj.slug)) {
                                        MediaItemCell(imageURL: sObj.album.image, title: sObj.slug, width: 140, height: 140)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
                .refreshable {
                    homeVM.refreshAllData()
                }
            }
        }
//        .id(homeVM.tracks.count)
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .alert(item: $homeVM.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
        .onAppear {
            mainVM.isTabBarVisible = true
            updateGreeting()
        }
    }
    
    @ViewBuilder
    private func playlistDestination(for playlist: Playlist) -> some View {
        if playlist.user.displayName == homeVM.user.displayName {
            MyPlaylistView(slugPlaylist: playlist.slug)
        } else {
            PlaylistView(slugPlaylist: playlist.slug)
        }
    }
    
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 5 && hour < 12 {
            greeting = "Good morning"
        } else if hour >= 12 && hour < 17 {
            greeting = "Good day"
        } else if hour >= 17 && hour < 21 {
            greeting = "Good evening"
        } else {
            greeting = "Good night"
        }
    }
}
