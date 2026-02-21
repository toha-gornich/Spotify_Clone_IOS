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
    @StateObject private var homeRouter = Router()
    @StateObject private var searchRouter = Router()
    @StateObject private var libraryRouter = Router()
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var genresVM = GenresViewModel()
    @StateObject private var libraryVM = LibraryViewModel()
    
    var body: some View {
        ZStack {
            // TabView
            TabView(selection: $mainVM.selectTab) {
                NavigationStack(path: $homeRouter.path){
                    HomeView(homeVM: homeVM).navigationDestination(for: AppRoute.self){route in
                        switch route{
                        case AppRoute.album(let slugAlbum):
                            AlbumView(slugAlbum: slugAlbum)
                        case AppRoute.track(let slugTrack):
                            TrackView(slugTrack: slugTrack)
                        case AppRoute.playlist(let slugPlaylist):
                            PlaylistView(slugPlaylist: slugPlaylist)
                        case AppRoute.artist(let slugArtist):
                            ArtistView(slugArtist: slugArtist)
                        default:
                            Text("Not implemented")
                        }
                    }
                }
                .environmentObject(homeRouter)
                .tag(0)
                
                NavigationStack(path: $searchRouter.path){
                    GenresView(genreVM: genresVM).navigationDestination(for: AppRoute.self){route in
                        switch route{
                        case AppRoute.album(let slugAlbum):
                            AlbumView(slugAlbum: slugAlbum)
                        case AppRoute.track(let slugTrack):
                            TrackView(slugTrack: slugTrack)
                        case AppRoute.playlist(let slugPlaylist):
                            PlaylistView(slugPlaylist: slugPlaylist)
                        case AppRoute.artist(let slugArtist):
                            ArtistView(slugArtist: slugArtist)
                        case AppRoute.genreDetails(let slugGenre):
                            GenreDetailsView(slugGenre: slugGenre, genresVM: genresVM)
                        case AppRoute.search(let searchText):
                            SearchView(searchText: searchText)
                        case AppRoute.profile(let profileId):
                            ProfileView(userId: profileId)
                        default:
                            Text("Not implemented")
                        }
                    }
                }
                
                .environmentObject(searchRouter)
                .tag(1)
                
                NavigationStack(path: $searchRouter.path){
                    LibraryView(libraryVM: libraryVM).navigationDestination(for: AppRoute.self){route in
                        switch route{
                        case AppRoute.album(let slugAlbum):
                            AlbumView(slugAlbum: slugAlbum)
                        case AppRoute.track(let slugTrack):
                            TrackView(slugTrack: slugTrack)
                        case AppRoute.playlist(let slugPlaylist):
                            PlaylistView(slugPlaylist: slugPlaylist)
                        case AppRoute.artist(let slugArtist):
                            ArtistView(slugArtist: slugArtist)
                        case .myPlaylist(let slugPlaylist):
                            MyPlaylistView(slugPlaylist: slugPlaylist)
                        default:
                            Text("Not implemented")
                        }
                        
                    }
                }
                .environmentObject(searchRouter)
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            // Tab Bar
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    TabButton(title: "Home", icon: "home_tab_f", iconUnfocus: "home_tab", isSelect: mainVM.selectTab == 0) {
                        if mainVM.selectTab == 0 {
                            homeRouter.goRoot()
                        } else {
                            mainVM.selectTab = 0
                        }
                    }
                    
                    Spacer()
                    
                    TabButton(title: "Search", icon: "search_tab_f", iconUnfocus: "search_tab", isSelect: mainVM.selectTab == 1) {
                        if mainVM.selectTab == 1 {
                            searchRouter.goRoot()
                        } else {
                            mainVM.selectTab = 1
                        }
                    }
                    
                    Spacer()
                    
                    TabButton(title: "Library", icon: "library_tab_f", iconUnfocus: "library_tab", isSelect: mainVM.selectTab == 2) {
                        if mainVM.selectTab == 2 {
                            libraryRouter.goRoot()
                        } else {
                            mainVM.selectTab = 2
                        }
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

        .environmentObject(mainVM)
        .environmentObject(playerManager)
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .onAppear {
            homeVM.loadAllDataIfNeeded()
        }
    }
}
