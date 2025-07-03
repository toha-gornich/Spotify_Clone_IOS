//
//  TrackRowCell.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 29.06.2025.
//

import SwiftUI
struct TrackRowCell: View {
    let track: Track
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // track number
            Text("\(index)")
                .font(.customFont(.medium, fontSize: 16))
                .foregroundColor(.secondaryText)
                .frame(width: 20, alignment: .center)
            
            // image album
            SpotifyRemoteImage(urlString: track.album.image)
                .frame(width: 50, height: 50)
                .cornerRadius(4)
            
            // info about track
            VStack(alignment: .leading, spacing: 2) {
                Text(track.title)
                    .font(.customFont(.medium, fontSize: 16))
                    .foregroundColor(.primaryText)
                    .lineLimit(1)
                
                Text(track.artist.displayName)
                    .font(.customFont(.regular, fontSize: 14))
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // duration track if exist
            if let duration = Int(track.duration)  {
                Text(formatDuration(Int(duration)))
                    .font(.customFont(.regular, fontSize: 14))
                    .foregroundColor(.secondaryText)
            }
            
            // button menu
            Button(action: {
                
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondaryText)
                    .font(.system(size: 16))
            }
        }
        
        .padding(.vertical, 8)
        .background(Color.clear)
        .onTapGesture {
            
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
