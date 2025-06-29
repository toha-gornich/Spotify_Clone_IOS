//
//  TrackGridCell.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 29.06.2025.
//

import SwiftUI

struct TrackGridCell: View {
    let track: Track
    
    var body: some View {
        HStack(spacing: 12) {
            SpotifyRemoteImage(urlString: track.album.image)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.customFont(.bold, fontSize: 13))
                    .foregroundColor(.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(track.artist.displayName)
                    .font(.customFont(.regular, fontSize: 11))
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.elementBg)
        .cornerRadius(8)
        .onTapGesture {
            // Дія при натисканні на трек
        }
    }
}

