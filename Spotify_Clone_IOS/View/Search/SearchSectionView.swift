//
//  SearchSectionView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct SearchSectionView<Item, Content: View>: View {
    let title: String
    let items: [Item]
    let content: (Item) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.customFont(.bold, fontSize: 18))
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Button("See all") {
                    
                }
                .font(.customFont(.medium, fontSize: 14))
                .foregroundColor(.green)
            }
            .padding(.horizontal, 20)
            
            LazyVStack(spacing: 8) {
                ForEach(items.indices, id: \.self) { index in
                    content(items[index])
                }
            }
        }
    }
}