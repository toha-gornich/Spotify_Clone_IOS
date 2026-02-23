//
//  ScrollableHeroView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 23.02.2026.
//


import SwiftUI

struct ScrollableHeroView: View {
    let imageURL: String
    let color: Color
    let imageHeight: CGFloat
    let overlayOpacity: CGFloat

    var body: some View {
        VStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.8),
                        color.opacity(0.4),
                        Color.bg
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(maxWidth: .infinity, maxHeight: imageHeight + 100)

                SpotifyRemoteImage(urlString: imageURL)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 250, maxHeight: imageHeight)
                    .padding(.top, 120)

                Color.bg
                    .opacity(overlayOpacity)
                    .animation(.easeOut(duration: 0.1), value: overlayOpacity)
            }
            .frame(maxWidth: .infinity, maxHeight: imageHeight)
            Spacer()
        }
        .ignoresSafeArea()
    }
}