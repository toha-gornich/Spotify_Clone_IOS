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
    let scrollOffset: CGFloat

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let stretchHeight = imageHeight + (scrollOffset > 0 ? scrollOffset : 0)
            let minY = scrollOffset > 0 ? -scrollOffset : 0
            
            // Розрахунок блюру: починається відразу при скролі вгору
            let blurRadius: CGFloat = scrollOffset < 0 ? min(abs(scrollOffset) / 15, 20) : 0

            ZStack(alignment: .bottomLeading) {
                // 1. Основа фону (прибирає сіру полоску)
                Color.bg
                    .frame(width: width, height: stretchHeight)
                    .offset(y: minY)

                // 2. Зображення з блюром
                SpotifyRemoteImage(urlString: imageURL)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: stretchHeight)
                    .blur(radius: blurRadius)
                    .clipped()
                    .offset(y: minY)

                // 3. Градієнт (тепер НЕ прозорий, а переходить у Color.bg)
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .black.opacity(0.3),
                        Color.bg // Перехід у суцільний колір фону
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: width, height: stretchHeight)
                .offset(y: minY)
            }
        }
        .frame(height: imageHeight)
        .ignoresSafeArea(.all) // Критично для прибирання полоски зверху
    }
}
