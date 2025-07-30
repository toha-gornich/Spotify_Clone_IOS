//
//  HomeView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var mainVM = MainViewModel.share
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    Button {
                        print("open Menu")
                        mainVM.isShowMenu = true
                    } label: {
                        Image("settings")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                    Text("Good morning")
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
                        .task{
                            homeVM.getTracks()
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
                        .task {
                            homeVM.getArtists()
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
                        .task {
                            homeVM.getAlbums()
                        }

                        
                        
                        ViewAllSection(title: "Popular playlists") {}

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(homeVM.playlists.indices, id: \.self) { index in
                                    let sObj = homeVM.playlists[index]
                                    NavigationLink(destination: PlaylistView(slugPlaylist: sObj.slug)) {
                                        MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                                    }
                                }
                            }
                        }
                        .task {
                            homeVM.getPlaylists()
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
                        .task {
                            homeVM.getTracks()
                        }

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
//            if homeVM.isLoading{
//                LoadingView()
//            }
        }
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .alert(item: $homeVM.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
        
        
    }
}
#Preview {
    NavigationView{
        
        MainView()
    }
}
