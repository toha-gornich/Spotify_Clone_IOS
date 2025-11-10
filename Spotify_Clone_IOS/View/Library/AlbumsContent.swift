//
//  AlbumsContent.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

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