//
//  AllSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct AllSearchContentView: View {
    @Binding var selectedTab: SearchTab
    @ObservedObject var searchVM: SearchViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 20) {
                if !searchVM.tracks.isEmpty {
                    
                    ViewAllSection(title: "Top result",buttonFlag: false)
                    
                    TopResultView(track: searchVM.tracks[0]).environmentObject(mainVM)
                        .environmentObject(playerManager)
                    
                    ViewAllSection(title: "Songs",buttonFlag: false )
                        .onTapGesture {selectedTab = SearchTab.songs}
                    
                    TrackListViewImage(tracks: searchVM.tracks, maxItems6: true, padding: 8).environmentObject(mainVM)
                        .environmentObject(playerManager)
                }
                
                if !searchVM.artists.isEmpty {
                    ViewAllSection(title: "Artists",buttonFlag: false )
                        .padding(.horizontal)
                        .onTapGesture {selectedTab = SearchTab.artists}
                    ArtistsSearchContentView(searchVM: searchVM, maxItems6: true, padding: 8).environmentObject(mainVM)
                        .environmentObject(playerManager)
                }
                
                if !searchVM.albums.isEmpty {
                    ViewAllSection(title: "Albums",buttonFlag: false )
                        .padding(.horizontal)
                        .onTapGesture {selectedTab = SearchTab.albums}
                    
                    AlbumsSearchContentView(searchVM: searchVM, maxItems6: true, padding: 8 ).environmentObject(mainVM)
                        .environmentObject(playerManager)
                }
                
                if !searchVM.playlists.isEmpty {
                    ViewAllSection(title: "Playlists",buttonFlag: false )
                        .padding(.horizontal)
                        .onTapGesture {selectedTab = SearchTab.playlists}
                    PlaylistsSearchContentView(searchVM: searchVM, maxItems6: true,  padding: 8).environmentObject(mainVM)
                        .environmentObject(playerManager)
                }
                if !searchVM.profiles.isEmpty {
                    ViewAllSection(title: "Profiles",buttonFlag: false )
                        .padding(.horizontal)
                    ProfilesSearchContentView(searchVM: searchVM, maxItems6: true,  padding: 8).environmentObject(mainVM)
                        .environmentObject(playerManager)
                }
            }
        }
//        .onAppear {
//            if !mainVM.isTabBarVisible {
//                mainVM.isTabBarVisible = false
//                print("Genres " + String(mainVM.isTabBarVisible))
//            }
//        }


        .padding(.bottom, 100)
        .padding(.horizontal)
    }
}
