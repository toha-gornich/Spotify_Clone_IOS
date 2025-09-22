//
//  MiniPlayerView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//

import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject var playerManager: AudioPlayerManager
    
    var body: some View {
        HStack {
            // Artwork
            AsyncImage(url: URL(string: playerManager.currentTrack?.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
            
            // Track Info
            VStack(alignment: .leading, spacing: 2) {
                Text(playerManager.currentTrack?.title ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(playerManager.currentTrack?.artistName ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Play/Pause Button
            Button(action: {
                playerManager.togglePlayPause()
            }) {
                Image(systemName: playerManager.playerState == .playing ? "pause.fill" : "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Color(hex: playerManager.currentTrack?.color ?? "")
        )
        .onTapGesture {
            playerManager.showFullPlayer()
        }
    }
}
