//
//  PlaylistsContent.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

struct PlaylistsContent: View {
    let playlists: [Playlist]
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var libraryVM: LibraryViewModel
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(playlists, id: \.slug) { playlist in
                NavigationLink(destination: {
                    if playlist.user.displayName == libraryVM.user.displayName {
                        MyPlaylistView(slugPlaylist: playlist.slug)
                            .environmentObject(mainVM)
                            .environmentObject(playerManager)
                    } else {
                        PlaylistView(slugPlaylist: playlist.slug)
                            .environmentObject(mainVM)
                            .environmentObject(playerManager)
                    }
                }) {
                    LibraryItemRow(
                        imageURL: playlist.image,
                        title: playlist.title,
                        subtitle: (playlist.user.displayName ?? "user")
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
