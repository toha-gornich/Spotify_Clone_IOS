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

enum RepeatMode {
    case off
    case one
    case all
}

class AudioPlayerManager: NSObject, ObservableObject {
    @Published var currentTrack: Track?
    @Published var playerState: PlayerState = .stopped
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var sheetState: SheetState = .hidden
    @Published var playlist: [Track] = []
    @Published var currentTrackIndex: Int = 0
    @Published var isShuffleEnabled: Bool = false
    @Published var repeatMode: RepeatMode = .off
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var originalPlaylist: [Track] = []
    
    // MARK: - Playback Control
    
    func play(track: Track, from playlist: [Track] = []) {
        // Перевіряємо чи це той самий трек що вже грає
        if let currentTrack = currentTrack,
           currentTrack.id == track.id,
           playerState == .playing {
            // Якщо той самий трек грає - ставимо на паузу
            togglePlayPause()
            return
        } else if let currentTrack = currentTrack,
                  currentTrack.id == track.id,
                  playerState == .paused {
            // Якщо той самий трек на паузі - продовжуємо відтворення
            togglePlayPause()
            return
        }
        
        // Якщо передано плейлист
        if !playlist.isEmpty {
            self.playlist = playlist
            self.originalPlaylist = playlist
            if let index = playlist.firstIndex(where: { $0.id == track.id }) {
                currentTrackIndex = index
            }
        }
        // Якщо тільки один трек
        else if self.playlist.isEmpty {
            self.playlist = [track]
            self.originalPlaylist = [track]
            currentTrackIndex = 0
        }
        // Якщо трек вже в поточному плейлисті
        else if let index = self.playlist.firstIndex(where: { $0.id == track.id }) {
            currentTrackIndex = index
        }
        
        playCurrentTrack()
    }
    
    func playPlaylist(_ tracks: [Track], startingAt index: Int = 0) {
        playlist = tracks
        originalPlaylist = tracks
        currentTrackIndex = index
        playCurrentTrack()
    }
    
    private func playCurrentTrack() {
        guard currentTrackIndex < playlist.count else { return }
        
        let track = playlist[currentTrackIndex]
        guard let audioURL = track.audioURL else {
            print("Invalid audio URL for track: \(track.title)")
            return
        }
        
        // Зупиняємо попереднього плеєра
        player?.pause()
        removeTimeObserver()
        
        currentTrack = track
        player = AVPlayer(url: audioURL)
        
        guard let player = player else { return }
        
        duration = track.durationInSeconds
        currentTime = 0
        playerState = .loading
        
        if sheetState == .hidden {
            sheetState = .mini
        }
        
        // Простіше - просто чекаємо трохи і запускаємо
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playerState = .playing
            player.play()
        }
        
        addTimeObserver()
        setupNowPlayingInfo(for: track)
        observePlaybackEnd()
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
        
        updateNowPlayingPlaybackRate()
    }
    
    // MARK: - Navigation Controls
    
    func nextTrack() {
        if repeatMode == .one {
            // Повторюємо поточний трек
            playCurrentTrack()
            return
        }
        
        if currentTrackIndex < playlist.count - 1 {
            currentTrackIndex += 1
            playCurrentTrack()
        } else if repeatMode == .all {
            // Повертаємося до початку плейлиста
            currentTrackIndex = 0
            playCurrentTrack()
        } else {
            // Кінець плейлиста
            playerState = .stopped
        }
    }
    
    func previousTrack() {
        // Якщо пройшло більше 3 секунд, перемотуємо на початок поточного треку
        if currentTime > 3.0 {
            player?.seek(to: .zero)
            return
        }
        
        if currentTrackIndex > 0 {
            currentTrackIndex -= 1
            playCurrentTrack()
        } else if repeatMode == .all {
            // Йдемо до останнього треку
            currentTrackIndex = playlist.count - 1
            playCurrentTrack()
        }
    }
    
    // MARK: - Shuffle & Repeat
    
    func toggleShuffle() {
        isShuffleEnabled.toggle()
        
        if isShuffleEnabled {
            // Перемішуємо плейлист, залишаючи поточний трек на першому місці
            var shuffledTracks = originalPlaylist
            if let currentTrack = currentTrack,
               let currentIndex = shuffledTracks.firstIndex(where: { $0.id == currentTrack.id }) {
                shuffledTracks.swapAt(0, currentIndex)
                let remainingTracks = Array(shuffledTracks.dropFirst()).shuffled()
                shuffledTracks = [shuffledTracks[0]] + remainingTracks
            } else {
                shuffledTracks.shuffle()
            }
            playlist = shuffledTracks
            currentTrackIndex = 0
        } else {
            // Повертаємо оригінальний порядок
            playlist = originalPlaylist
            if let currentTrack = currentTrack,
               let originalIndex = originalPlaylist.firstIndex(where: { $0.id == currentTrack.id }) {
                currentTrackIndex = originalIndex
            }
        }
    }
    
    func toggleRepeat() {
        switch repeatMode {
        case .off:
            repeatMode = .all
        case .all:
            repeatMode = .one
        case .one:
            repeatMode = .off
        }
    }
    
    // MARK: - UI Controls
    
    func showFullPlayer() {
        sheetState = .full
    }
    
    func dismissPlayer() {
        sheetState = .hidden
        player?.pause()
        playerState = .stopped
        removeTimeObserver()
    }
    
    func hidePlayer() {
        sheetState = .hidden
    }
    
    // MARK: - Seek
    
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
        currentTime = time
    }
    
    // MARK: - Private Methods
    
    private func setupNowPlayingInfo(for track: Track) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = track.artistName
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = track.albumTitle
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = track.durationInSeconds
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerState == .playing ? 1.0 : 0.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func updateNowPlayingPlaybackRate() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerState == .playing ? 1.0 : 0.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func addTimeObserver() {
        removeTimeObserver()
        guard let player = player else { return }
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            guard time.isValid && !time.isIndefinite else { return }
            self?.currentTime = time.seconds
            self?.updateNowPlayingPlaybackRate()
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    private func observePlaybackEnd() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.nextTrack()
        }
    }
    
    // MARK: - Helper Methods
    
    func isPlaying(track: Track) -> Bool {
        return currentTrack?.id == track.id && playerState == .playing
    }
    
    func isPaused(track: Track) -> Bool {
        return currentTrack?.id == track.id && playerState == .paused
    }
    
    func isCurrentTrack(_ track: Track) -> Bool {
        return currentTrack?.id == track.id
    }
    
    // MARK: - KVO Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let player = object as? AVPlayer {
            switch player.status {
            case .readyToPlay:
                DispatchQueue.main.async {
                    self.playerState = .playing
                    player.play()
                }
            case .failed:
                DispatchQueue.main.async {
                    self.playerState = .stopped
                    print("Player failed with error: \(player.error?.localizedDescription ?? "Unknown error")")
                }
            case .unknown:
                DispatchQueue.main.async {
                    self.playerState = .loading
                }
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        removeTimeObserver()
        player?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
    }
}
