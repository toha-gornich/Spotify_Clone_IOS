//
//  PlaylistsContent.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

struct PlaylistsContent: View {
    @EnvironmentObject var router:Router
    let libraryVM: LibraryViewModel
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(libraryVM.playlists, id: \.slug) { playlist in
                let isMyPlaylist = playlist.user.displayName == libraryVM.user.displayName
                
                Button() {
                    if isMyPlaylist {
                        router.navigateTo(AppRoute.myPlaylist(slugPlaylist: playlist.slug))
                    } else {
                        router.navigateTo(AppRoute.playlist(slugPlaylist: playlist.slug))
                    }
                } label: {
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
