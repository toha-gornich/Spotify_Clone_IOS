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
            Color.bg.ignoresSafeArea()
            
            TabView(selection: $mainVM.selectTab) {
                NavigationStack(path: $homeRouter.path) {
                    HomeView(homeVM: homeVM)
                        .navigationDestination(for: AppRoute.self) { destinations(route: $0) }
                }
                .environmentObject(homeRouter)
                .tag(0)
                
                NavigationStack(path: $searchRouter.path) {
                    GenresView(genreVM: genresVM)
                        .navigationDestination(for: AppRoute.self) { destinations(route: $0) }
                }
                .environmentObject(searchRouter)
                .tag(1)
                
                NavigationStack(path: $libraryRouter.path) {
                    LibraryView(libraryVM: libraryVM)
                        .navigationDestination(for: AppRoute.self) { destinations(route: $0) }
                }
                .environmentObject(libraryRouter)
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(.container, edges: .top) // content extends under status bar
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            VStack {
                Spacer()
                tabBarView
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bg)
        .environmentObject(mainVM)
        .environmentObject(playerManager)
        .onAppear {
            homeVM.loadAllDataIfNeeded()
        }
    }
    
    // MARK: - Tab Bar
    private var tabBarView: some View {
        HStack {
            Spacer()
            TabButton(title: "Home", icon: "home_tab_f", iconUnfocus: "home_tab", isSelect: mainVM.selectTab == 0) {
                if mainVM.selectTab == 0 { homeRouter.goRoot() } else { mainVM.selectTab = 0 }
            }
            Spacer()
            TabButton(title: "Search", icon: "search_tab_f", iconUnfocus: "search_tab", isSelect: mainVM.selectTab == 1) {
                if mainVM.selectTab == 1 { searchRouter.goRoot() } else { mainVM.selectTab = 1 }
            }
            Spacer()
            TabButton(title: "Library", icon: "library_tab_f", iconUnfocus: "library_tab", isSelect: mainVM.selectTab == 2) {
                if mainVM.selectTab == 2 { libraryRouter.goRoot() } else { mainVM.selectTab = 2 }
            }
            Spacer()
        }
        .padding(.top, 10)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.bg.opacity(0.6),
                    Color.bg.opacity(1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.container, edges: .bottom)
        )
        .shadow(radius: 2)
    }
    
    // MARK: - Navigation Destinations
    @ViewBuilder
    private func destinations(route: AppRoute) -> some View {
        switch route {
        case .album(let slug):        AlbumView(slugAlbum: slug)
        case .track(let slug):        TrackView(slugTrack: slug)
        case .playlist(let slug):     PlaylistView(slugPlaylist: slug)
        case .artist(let slug):       ArtistView(slugArtist: slug)
        case .myPlaylist(let slug):   MyPlaylistView(slugPlaylist: slug)
        case .genreDetails(let slug): GenreDetailsView(slugGenre: slug, genresVM: genresVM)
        case .search(let text):       SearchView(searchText: text)
        case .profile(let id):        ProfileView(userId: id)
        }
    }
}
