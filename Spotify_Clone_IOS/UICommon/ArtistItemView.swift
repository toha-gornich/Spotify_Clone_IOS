//
//  ArtistItemView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.07.2025.
//

import SwiftUI

struct ArtistItemView: View {
    let displayName: String
    let imageURL: String
    
    var body: some View {
        VStack {
            SpotifyRemoteImage(urlString: imageURL)
                .frame(width: 140, height: 140)
                .clipShape(Circle())
            
            Text(displayName)
                .font(.customFont(.bold, fontSize: 13))
                .foregroundColor(.primaryText)
                .lineLimit(2)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension ArtistItemView {
    init(artist: Artist) {
        self.init(displayName: artist.displayName, imageURL: artist.image)
    }
    
    init(user: User) {
        self.init(displayName: (user.displayName ?? "name"), imageURL: (user.image) ?? "image not found")
    }
}

