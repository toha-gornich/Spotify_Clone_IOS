//
//  SearchTrackRow.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

struct SearchTrackRow: View {
    let track: Track
    let isInPlaylist: Bool
    let onToggle: () async -> Bool
    
    @State private var isProcessing = false
    @State private var showError = false
    
    var body: some View {
        HStack(spacing: 12) {

                SpotifyRemoteImage(urlString: track.album.image)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
           
            // Track Info
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(track.artist.displayName)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Add/Remove Button
            Button(action: {
                Task {
                    await handleToggle()
                }
            }) {
                ZStack {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: isInPlaylist ? "minus.circle.fill" : "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(isInPlaylist ? .red : .green)
                    }
                }
                .frame(width: 32, height: 32)
            }
            .disabled(isProcessing)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(isInPlaylist ? "Failed to remove track from playlist" : "Failed to add track to playlist")
        }
    }
    
    private func handleToggle() async {
        isProcessing = true
        
        let success = await onToggle()
        
        if !success {
            showError = true
        }
        
        isProcessing = false
    }
}
