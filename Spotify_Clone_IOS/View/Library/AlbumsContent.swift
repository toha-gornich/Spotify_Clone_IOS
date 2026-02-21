//
//  AlbumsContent.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

struct AlbumsContent: View {
    let albums: [Album]
    @EnvironmentObject var router:Router

    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(albums, id: \.slug) { album in
                Button(){
                    router.navigateTo(AppRoute.album(slugAlbum: album.slug))
                }label: {
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
