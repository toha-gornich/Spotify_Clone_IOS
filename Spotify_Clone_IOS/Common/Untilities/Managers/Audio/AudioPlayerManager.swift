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
    private var artworkCache: [String: UIImage] = [:]
    
    override init() {
        super.init()
        setupRemoteCommandCenter()
        setupAudioSession()
    }
    
    // MARK: - Remote Command Center Setup
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Play command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }
        
        // Pause command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }
        
        // Next track command
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextTrack()
            return .success
        }
        
        // Previous track command
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousTrack()
            return .success
        }
        
        // Change playback position command
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            self?.seek(to: event.positionTime)
            return .success
        }
    }
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    
    func play(track: Track?, from playlist: [Track] = []) {
        if track == nil {
            return
        }
        let newTrack = track!
        if let currentTrack = currentTrack,
           currentTrack.id == newTrack.id,
           playerState == .playing {
            togglePlayPause()
            return
        } else if let currentTrack = currentTrack,
                  currentTrack.id == newTrack.id,
                  playerState == .paused {
            togglePlayPause()
            return
        }
        
        if !playlist.isEmpty {
            self.playlist = playlist
            self.originalPlaylist = playlist
            if let index = playlist.firstIndex(where: { $0.id == newTrack.id }) {
                currentTrackIndex = index
            }
        }
        
        else if self.playlist.isEmpty {
            self.playlist = [newTrack]
            self.originalPlaylist = [newTrack]
            currentTrackIndex = 0
        }
        
        else if let index = self.playlist.firstIndex(where: { $0.id == newTrack.id }) {
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
    
    func nextTrack() {
        if repeatMode == .one {
            playCurrentTrack()
            return
        }
        
        if currentTrackIndex < playlist.count - 1 {
            currentTrackIndex += 1
            playCurrentTrack()
        } else if repeatMode == .all {
            currentTrackIndex = 0
            playCurrentTrack()
        } else {
            playerState = .stopped
        }
    }
    
    func previousTrack() {
        if currentTime > 3.0 {
            player?.seek(to: .zero)
            return
        }
        
        if currentTrackIndex > 0 {
            currentTrackIndex -= 1
            playCurrentTrack()
        } else if repeatMode == .all {
            currentTrackIndex = playlist.count - 1
            playCurrentTrack()
        }
    }
    
    func toggleShuffle() {
        isShuffleEnabled.toggle()
        
        if isShuffleEnabled {
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
    
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
        currentTime = time
        updateNowPlayingPlaybackRate()
    }
    
    // MARK: - Now Playing Info
    private func setupNowPlayingInfo(for track: Track) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = track.artistName
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = track.albumTitle
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = track.durationInSeconds
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerState == .playing ? 1.0 : 0.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        // Завантажуємо artwork асинхронно
        loadArtworkImageAsync(for: track) { image in
            guard let image = image else { return }
            var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            info[MPMediaItemPropertyArtwork] = artwork
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }
    }
    
    private func loadArtworkImageAsync(for track: Track, completion: @escaping (UIImage?) -> Void) {
            // Отримуємо URL картинки з треку
            let imageURLString = track.album.image
            guard let imageURL = URL(string: imageURLString) else {
                completion(getPlaceholderImage())
                return
            }
            
            // Перевіряємо кеш
            let cacheKey = String(track.id)
            if let cachedImage = artworkCache[cacheKey] {
                completion(cachedImage)
                return
            }
            
            // Loading image
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let data = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.artworkCache[cacheKey] = image
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(self?.getPlaceholderImage())
                    }
                }
            }
        }
    
    private func getPlaceholderImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 200, weight: .light)
        return UIImage(systemName: "music.note", withConfiguration: config)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
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
    
    func isPlaying(track: Track) -> Bool {
        return currentTrack?.id == track.id && playerState == .playing
    }
    
    func isPaused(track: Track) -> Bool {
        return currentTrack?.id == track.id && playerState == .paused
    }
    
    func isCurrentTrack(_ track: Track) -> Bool {
        return currentTrack?.id == track.id
    }
    
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
    
    deinit {
        removeTimeObserver()
        player?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        
        // Вимкнути команди при знищенні
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = false
        commandCenter.pauseCommand.isEnabled = false
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
        commandCenter.changePlaybackPositionCommand.isEnabled = false
    }
}
