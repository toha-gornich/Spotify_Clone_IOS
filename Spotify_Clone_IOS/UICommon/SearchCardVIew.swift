//
//  SearchCardVIew.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.07.2025.
//

import SwiftUI

struct SearchCardView: View {
    var genre: Genre
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: genre.color))
                .frame(height: 120)
                .overlay(
                    
                    SpotifyRemoteImage(urlString: genre.image)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedCorner(radius: 8, corner: [.topLeft, .topRight, .bottomLeft, .bottomRight]))
                        .rotationEffect(.degrees(20))
                        .offset(x: 30, y: 30),
                    
                    
                    alignment: .bottomTrailing
                )
                .clipShape(
                    RoundedCorner(radius: 12, corner: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                )
                .overlay(
                    Text(genre.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding([.top, .leading], 16),
                    alignment: .topLeading
                )
        }

    }
}
