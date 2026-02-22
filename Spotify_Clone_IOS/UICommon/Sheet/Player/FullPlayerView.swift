//
//  FullPlayerView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//

import SwiftUI
import SwiftUI

struct FullPlayerView: View {
    @ObservedObject var playerManager: AudioPlayerManager
    @State private var seekValue: Double = 0
    @State private var isDragging = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: playerManager.currentTrack?.album.color ?? "1C1C1E"),
                    Color(hex: playerManager.currentTrack?.album.color ?? "1C1C1E").opacity(0.5)
                ]),
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
                        .lineLimit(1)

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

                // Album Image
                if let track = playerManager.currentTrack {
                    SpotifyRemoteImage(urlString: track.album.image)
                        .frame(width: 300, height: 300)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        .scaleEffect(playerManager.playerState == .playing ? 1.0 : 0.85)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: playerManager.playerState)
                }

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

                // Slider + Time
                VStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: {
                                // While dragging — show seekValue, otherwise — currentTime
                                isDragging ? seekValue : playerManager.currentTime
                            },
                            set: { newValue in
                                seekValue = newValue
                                // Only update UI while dragging, no actual seek yet
                                playerManager.updateSeekTime(newValue)
                            }
                        ),
                        in: 0...max(playerManager.duration, 1)
                    )
                    .accentColor(.white)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if !isDragging {
                                    isDragging = true
                                    seekValue = playerManager.currentTime
                                }
                            }
                            .onEnded { _ in
                                // Actual seek only when finger is released
                                playerManager.seek(to: seekValue)
                                isDragging = false
                            }
                    )

                    HStack {
                        Text(timeString(from: isDragging ? seekValue : playerManager.currentTime))
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))

                        Spacer()

                        Text("-\(timeString(from: playerManager.duration - (isDragging ? seekValue : playerManager.currentTime)))")
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

                    Button(action: {
                        playerManager.toggleRepeat()
                    }) {
                        Image(systemName: repeatIcon)
                            .font(.system(size: 20))
                            .foregroundColor(playerManager.repeatMode == .off ? .white : .green)
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
                    if value.translation.height > 100 {
                        playerManager.sheetState = .mini
                    }
                }
        )
        // Alert for loading errors
        .alert("Error", isPresented: Binding(
            get: { playerManager.errorMessage != nil },
            set: { if !$0 { playerManager.errorMessage = nil } }
        )) {
            Button("OK") { playerManager.errorMessage = nil }
        } message: {
            Text(playerManager.errorMessage ?? "")
        }
    }

    // Repeat icon based on current mode
    private var repeatIcon: String {
        switch playerManager.repeatMode {
        case .off: return "repeat"
        case .all: return "repeat"
        case .one: return "repeat.1"
        }
    }

    private func timeString(from timeInterval: TimeInterval) -> String {
        let safeInterval = max(0, timeInterval)
        let minutes = Int(safeInterval) / 60
        let seconds = Int(safeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
