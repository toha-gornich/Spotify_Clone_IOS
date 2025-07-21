//
//  SearchCardVIew.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.07.2025.
//

import SwiftUI

struct SearchCardView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.8))
                .frame(height: 120)
                .overlay(
                    // Фото в правому нижньому кутку
                    Image("img_3")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedCorner(radius: 8, corner: [.topLeft, .topRight, .bottomLeft, .bottomRight]))
                        .rotationEffect(.degrees(20))
                        .offset(x: 10, y: 10),
                // частково виходить за межі
                    
                    
                    alignment: .bottomTrailing
                )
                .clipShape(
                    RoundedCorner(radius: 12, corner: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                )
                .overlay(
                    Text("Summer")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding([.top, .leading], 16),
                    alignment: .topLeading
                )
        }
        .padding()
    }
}


#Preview {
    SearchCardView()
}
