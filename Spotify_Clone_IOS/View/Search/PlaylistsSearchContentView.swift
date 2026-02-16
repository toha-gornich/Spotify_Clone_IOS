//
//  PlaylistsSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct PlaylistsSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    let maxItems6: Bool
    let padding: Int
    let onLoadMore: (() -> Void)?
    let isLoading: Bool
    
    private var limitedItems: [Playlist] {
        if maxItems6 {
            Array(searchVM.playlists.prefix(6))
        } else {
            Array(searchVM.playlists)
        }
    }
    
    init(
        searchVM: SearchViewModel,
        maxItems6: Bool = false,
        padding: Int = 70,
        onLoadMore: (() -> Void)? = nil,
        isLoading: Bool = false
    ) {
        self.searchVM = searchVM
        self.maxItems6 = maxItems6
        self.padding = padding
        self.onLoadMore = onLoadMore
        self.isLoading = isLoading
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(Array(limitedItems.enumerated()), id: \.offset) { index, playlist in
                    NavigationLink(destination: {
                        if playlist.user.displayName == searchVM.user.displayName {
                            MyPlaylistView(slugPlaylist: playlist.slug)
                                .environmentObject(mainVM)
                                .environmentObject(playerManager)
                        } else {
                            PlaylistView(slugPlaylist: playlist.slug)
                                .environmentObject(mainVM)
                                .environmentObject(playerManager)
                        }
                    }) {
                        MediaItemCell(
                            imageURL: playlist.image,
                            title: playlist.title,
                            width: 140,
                            height: 140
                        )
                    }
                    .onAppear {
                        if index == limitedItems.count - 2 && !maxItems6 {
                            onLoadMore?()
                        }
                    }
                }
            }
            
            // Loading indicator
            if isLoading && !maxItems6 {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
            }
        }
        .padding(.bottom, CGFloat(padding))
    }
}
