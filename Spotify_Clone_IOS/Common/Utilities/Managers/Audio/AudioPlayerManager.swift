//
//  AudioPlayerManager.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.

import SwiftUI
import AVFoundation
import MediaPlayer
import Combine
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
    @Published var errorMessage: String?

    private var player: AVQueuePlayer?
    private var timeObserver: Any?
    private var originalPlaylist: [Track] = []
    private var shuffledIndices: [Int] = []
    private let artworkCache = NSCache<NSString, UIImage>()
    private var cancellables = Set<AnyCancellable>()
    private var currentItemObservation: NSKeyValueObservation?
    private var currentItemChangeObservation: NSKeyValueObservation?
    private var isSeeking = false

    override init() {
        super.init()
        setupRemoteCommandCenter()
        setupAudioSession()
        setupInterruptionHandling()
    }

    // MARK: - Audio Session
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    // MARK: - Interruption Handling
    private func setupInterruptionHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
    }

    @objc private func handleInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let type = AVAudioSession.InterruptionType(rawValue: info[AVAudioSessionInterruptionTypeKey] as? UInt ?? 0)
        else { return }

        switch type {
        case .began:
            if playerState == .playing { player?.pause(); playerState = .paused }
        case .ended:
            if let opts = info[AVAudioSessionInterruptionOptionKey] as? UInt,
               AVAudioSession.InterruptionOptions(rawValue: opts).contains(.shouldResume) {
                player?.play(); playerState = .playing
            }
        @unknown default: break
        }
    }

    // MARK: - Remote Command Center
    private func setupRemoteCommandCenter() {
        let cc = MPRemoteCommandCenter.shared()

        addCommand(cc.playCommand)  { [weak self] _ in self?.togglePlayPause() }
        addCommand(cc.pauseCommand) { [weak self] _ in self?.togglePlayPause() }
        addCommand(cc.nextTrackCommand)     { [weak self] _ in self?.nextTrack() }
        addCommand(cc.previousTrackCommand) { [weak self] _ in self?.previousTrack() }

        cc.changePlaybackPositionCommand.isEnabled = true
        cc.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self?.seek(to: event.positionTime)
            return .success
        }
    }

    private func addCommand(_ command: MPRemoteCommand, handler: @escaping (MPRemoteCommandEvent) -> Void) {
        command.isEnabled = true
        command.addTarget { event in handler(event); return .success }
    }

    // MARK: - Play
    func play(track: Track?, from playlist: [Track] = []) {
        guard let newTrack = track else { return }

        if currentTrack?.id == newTrack.id { togglePlayPause(); return }

        if !playlist.isEmpty {
            self.playlist = playlist
            self.originalPlaylist = playlist
            currentTrackIndex = playlist.firstIndex(where: { $0.id == newTrack.id }) ?? 0
        } else if self.playlist.isEmpty {
            self.playlist = [newTrack]
            self.originalPlaylist = [newTrack]
            currentTrackIndex = 0
        } else {
            currentTrackIndex = self.playlist.firstIndex(where: { $0.id == newTrack.id }) ?? currentTrackIndex
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
        guard currentTrackIndex < playlist.count,
              let audioURL = playlist[currentTrackIndex].audioURL else { return }

        let track = playlist[currentTrackIndex]

        player?.pause()
        removeTimeObserver()
        currentItemObservation?.invalidate()

        currentTrack = track
        playerState = .loading
        if sheetState == .hidden { sheetState = .mini }

        let currentItem = AVPlayerItem(url: audioURL)
        player = AVQueuePlayer(playerItem: currentItem)
        preloadNextTrack()

        currentItemChangeObservation?.invalidate()
        currentItemChangeObservation = player?.observe(\.currentItem, options: [.new, .old]) { [weak self] _, change in
            guard let self, change.oldValue != nil, change.newValue is AVPlayerItem else { return }
            DispatchQueue.main.async {
                let nextIndex = self.currentTrackIndex + 1
                guard nextIndex < self.playlist.count else { return }
                self.currentTrackIndex = nextIndex
                self.currentTrack = self.playlist[nextIndex]
                self.duration = self.playlist[nextIndex].durationInSeconds
                self.currentTime = 0
                self.setupNowPlayingInfo(for: self.playlist[nextIndex])
                self.preloadNextTrack()
            }
        }

        currentItemObservation = currentItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                switch item.status {
                case .readyToPlay: self?.player?.play(); self?.playerState = .playing
                case .failed:      self?.playerState = .stopped; self?.errorMessage = item.error?.localizedDescription ?? "Failed to load track"
                case .unknown:     self?.playerState = .loading
                @unknown default:  break
                }
            }
        }

        duration = track.durationInSeconds
        currentTime = 0
        addTimeObserver()
        setupNowPlayingInfo(for: track)
        observePlaybackEnd()
    }

    private func preloadNextTrack() {
        let nextIndex = currentTrackIndex + 1
        guard nextIndex < playlist.count, let nextURL = playlist[nextIndex].audioURL else { return }
        player?.insert(AVPlayerItem(url: nextURL), after: player?.items().last)
    }

    // MARK: - Controls
    func togglePlayPause() {
        guard let player else { return }
        if playerState == .playing { player.pause(); playerState = .paused }
        else { player.play(); playerState = .playing }
        updateNowPlayingPlaybackRate()
    }

    func nextTrack() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if repeatMode == .one { playCurrentTrack(); return }

        if currentTrackIndex < playlist.count - 1 {
            currentTrackIndex += 1; playCurrentTrack()
        } else if repeatMode == .all {
            currentTrackIndex = 0; playCurrentTrack()
        } else {
            player?.pause(); player?.seek(to: .zero)
            playerState = .stopped; currentTime = 0
            updateNowPlayingPlaybackRate()
        }
    }

    func previousTrack() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if currentTime > 3.0 { seek(to: 0); return }

        if currentTrackIndex > 0 {
            currentTrackIndex -= 1; playCurrentTrack()
        } else if repeatMode == .all {
            currentTrackIndex = playlist.count - 1; playCurrentTrack()
        }
    }

    // MARK: - Shuffle
    func toggleShuffle() {
        isShuffleEnabled.toggle()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if isShuffleEnabled {
            var indices = Array(originalPlaylist.indices)
            if let current = originalPlaylist.firstIndex(where: { $0.id == currentTrack?.id }) {
                indices.removeAll { $0 == current }
                shuffledIndices = [current] + indices.shuffled()
            } else {
                shuffledIndices = indices.shuffled()
            }
            playlist = shuffledIndices.map { originalPlaylist[$0] }
            currentTrackIndex = 0
        } else {
            playlist = originalPlaylist
            currentTrackIndex = originalPlaylist.firstIndex(where: { $0.id == currentTrack?.id }) ?? currentTrackIndex
        }
        rebuildQueue()
    }

    private func rebuildQueue() {
        guard let player else { return }
        let current = player.currentItem
        player.items().filter { $0 != current }.forEach { player.remove($0) }
        preloadNextTrack()
    }

    func toggleRepeat() {
        repeatMode = repeatMode == .off ? .all : repeatMode == .all ? .one : .off
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    // MARK: - Sheet
    func showFullPlayer() { sheetState = .full }
    func hidePlayer()     { sheetState = .hidden }
    func dismissPlayer()  { sheetState = .hidden; player?.pause(); playerState = .stopped; removeTimeObserver() }

    // MARK: - Seek
    func updateSeekTime(_ time: TimeInterval) { currentTime = time }

    func seek(to time: TimeInterval) {
        guard !isSeeking else { return }
        isSeeking = true
        let cmTime = CMTime(seconds: time, preferredTimescale: 1000)
        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            self?.isSeeking = false
            self?.updateNowPlayingPlaybackRate()
        }
        currentTime = time
    }

    // MARK: - Now Playing Info
    private func setupNowPlayingInfo(for track: Track) {
        var info: [String: Any] = [
            MPMediaItemPropertyTitle:            track.title,
            MPMediaItemPropertyArtist:           track.artistName,
            MPMediaItemPropertyAlbumTitle:       track.albumTitle,
            MPMediaItemPropertyPlaybackDuration: track.durationInSeconds,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPNowPlayingInfoPropertyPlaybackRate: 1.0
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info

        loadArtworkImageAsync(for: track) { image in
            guard let image else { return }
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }
    }

    private func updateNowPlayingPlaybackRate() {
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        info[MPNowPlayingInfoPropertyPlaybackRate] = playerState == .playing ? 1.0 : 0.0
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    // MARK: - Artwork
    private func loadArtworkImageAsync(for track: Track, completion: @escaping (UIImage?) -> Void) {
        let key = NSString(string: String(track.id))
        if let cached = artworkCache.object(forKey: key) { completion(cached); return }

        guard let url = URL(string: track.album.image) else { completion(getPlaceholderImage()); return }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let image = (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
            if let image { self?.artworkCache.setObject(image, forKey: key) }
            DispatchQueue.main.async { completion(image ?? self?.getPlaceholderImage()) }
        }
    }

    private func getPlaceholderImage() -> UIImage? {
        UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 200, weight: .light))?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
    }

    // MARK: - Time Observer
    private func addTimeObserver() {
        guard let player else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard time.isValid && !time.isIndefinite else { return }
            self?.currentTime = time.seconds
            self?.updateNowPlayingPlaybackRate()
        }
    }

    private func removeTimeObserver() {
        if let observer = timeObserver { player?.removeTimeObserver(observer); timeObserver = nil }
    }

    private func observePlaybackEnd() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.nextTrack()
        }
    }

    // MARK: - Helpers
    func isPlaying(track: Track) -> Bool  { currentTrack?.id == track.id && playerState == .playing }
    func isPaused(track: Track) -> Bool   { currentTrack?.id == track.id && playerState == .paused }
    func isCurrentTrack(_ track: Track) -> Bool { currentTrack?.id == track.id }
    func isPlaying(trackSlug: String) -> Bool   { currentTrack?.slug == trackSlug && playerState == .playing }

    // MARK: - Deinit
    deinit {
        removeTimeObserver()
        currentItemObservation?.invalidate()
        currentItemChangeObservation?.invalidate()
        NotificationCenter.default.removeObserver(self)

        let cc = MPRemoteCommandCenter.shared()
        [cc.playCommand, cc.pauseCommand, cc.nextTrackCommand, cc.previousTrackCommand, cc.changePlaybackPositionCommand]
            .forEach { $0.isEnabled = false }
    }
}
