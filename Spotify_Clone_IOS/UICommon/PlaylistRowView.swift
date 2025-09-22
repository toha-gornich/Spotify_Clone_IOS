//
//  PlaylistRowView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.09.2025.
//

import SwiftUI

struct PlaylistRowView: View {
    let title: String
    let imageURL: String
    let author: String
    
    var body: some View {
        HStack(spacing: 12) {
            SpotifyRemoteImage(urlString: imageURL)
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(author)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
