//
//  ArtistItemView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.07.2025.
//

import SwiftUI

struct ArtistItemView: View {
    let artist: Artist
    
    var body: some View {
        VStack {
            SpotifyRemoteImage(urlString: artist.image)
                .frame(width: 140, height: 140)
                .clipShape(Circle())
            
            Text(artist.displayName)
                .font(.customFont(.bold, fontSize: 13))
                .foregroundColor(.primaryText)
                .lineLimit(2)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}

