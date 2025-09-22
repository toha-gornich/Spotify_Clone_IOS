//
//  AudioPlayerManager.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//

import SwiftUI
import AVFoundation
import MediaPlayer

enum PlayerState {
    case stopped
    case playing
    case paused
    case loading
}

enum SheetState {
    case hidden
    case mini
    case full
}

class AudioPlayerManager: ObservableObject {
    @Published var currentTrack: Track?
    @Published var playerState: PlayerState = .stopped
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var sheetState: SheetState = .hidden
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
        
    func play(track: Track) {
        guard let audioURL = track.audioURL else {
            print("Invalid audio URL for track: \(track.title)")
            return
        }
        
        currentTrack = track
        player = AVPlayer(url: audioURL)
        duration = track.durationInSeconds
        playerState = .playing
        sheetState = .mini
        player?.play()
        addTimeObserver()
        
        // Setup Now Playing Info
        setupNowPlayingInfo(for: track)
    }
    
    private func setupNowPlayingInfo(for track: Track) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = track.artistName
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = track.albumTitle
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = track.durationInSeconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerState == .playing ? 1.0 : 0.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if playerState == .playing {
            player.pause()
            playerState = .paused
        } else {
            player.play()
            playerState = .playing
        }
    }
    
    func showFullPlayer() {
        sheetState = .full
    }
    
    func dismissPlayer() {
        sheetState = .hidden
        player?.pause()
        playerState = .stopped
    }
    
    private func addTimeObserver() {
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 1),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
}
