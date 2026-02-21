//
//  ArtistsContent.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

struct ArtistsContent: View {
    let artists: [ArtistTrack]
    @EnvironmentObject var router:Router
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(artists, id: \.slug) { artist in
                Button(){
                    router.navigateTo(AppRoute.artist(slugArtist: artist.slug))
                }label: {
                    LibraryItemRow(
                        imageURL: artist.image,
                        title: artist.displayName,
                        subtitle: "Artist"
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
