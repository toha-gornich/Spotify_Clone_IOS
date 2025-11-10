//
//  LibraryItemRow.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

struct LibraryItemRow: View {
    let imageURL: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 56, height: 56)
            .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.customFont(.medium, fontSize: 16))
                    .foregroundColor(.primaryText)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.customFont(.regular, fontSize: 14))
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}