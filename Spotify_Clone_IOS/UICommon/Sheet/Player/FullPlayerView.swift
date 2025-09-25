//
//  FullPlayerView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//

import SwiftUI


struct FullPlayerView: View {
    @ObservedObject var playerManager: AudioPlayerManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex:playerManager.currentTrack!.album.color), Color(hex:playerManager.currentTrack!.album.color).opacity(0.5)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Controls
                HStack {
                    Button(action: {
                        playerManager.sheetState = .mini
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(playerManager.currentTrack?.title ?? "")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                SpotifyRemoteImage(urlString: playerManager.currentTrack!.album.image)
                    .frame(width: 300, height: 300)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Spacer()
                
                // Track Info
                VStack(spacing: 8) {
                    Text(playerManager.currentTrack?.title ?? "")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(playerManager.currentTrack?.artistName ?? "")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Progress Bar
                VStack(spacing: 8) {
                    ProgressView(value: playerManager.currentTime, total: playerManager.duration)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .background(Color.white.opacity(0.3))
                    
                    HStack {
                        Text(timeString(from: playerManager.currentTime))
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("-\(timeString(from: playerManager.duration - playerManager.currentTime))")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 40)
                
                // Player Controls
                HStack(spacing: 28) {
                    Button(action: {
                        playerManager.toggleShuffle()
                    }) {
                        Image(systemName: "shuffle")
                            .font(.system(size: 20))
                            .foregroundColor(playerManager.isShuffleEnabled ? .green : .white)
                    }
                    
                    Button(action: {
                        playerManager.previousTrack()
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        playerManager.togglePlayPause()
                    }) {
                        Image(systemName: playerManager.playerState == .playing ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        playerManager.nextTrack()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "timer")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                
                // Bottom Controls
                HStack(spacing: 60) {
                    Button(action: {}) {
                        Image(systemName: "speaker.wave.2")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 30)
                .padding(.bottom, 40)
                
            }
        }

        .gesture(
            DragGesture()
                .onEnded { value in
                    // Якщо свайп вниз більше 100 пікселів
                    if value.translation.height > 100 {
                        playerManager.sheetState = .mini
                    }
                }
        )
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
