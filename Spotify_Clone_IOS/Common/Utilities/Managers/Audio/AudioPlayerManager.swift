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

    // MARK: - Private
    private var player: AVQueuePlayer?
    private var timeObserver: Any?
    private var originalPlaylist: [Track] = []
    private var shuffledIndices: [Int] = []

    // NSCache замість [String: UIImage] — автоматично чистить пам'ять
    private let artworkCache = NSCache<NSString, UIImage>()

    private var cancellables = Set<AnyCancellable>()
    private var currentItemObservation: NSKeyValueObservation?
    private var currentItemChangeObservation: NSKeyValueObservation?
    private var isSeeking = false

    // Публічна помилка для показу Alert у View
    @Published var errorMessage: String?

    override init() {
        super.init()
        setupRemoteCommandCenter()
        setupAudioSession()
        setupInterruptionHandling()
    }

    // MARK: - Audio Session
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    // MARK: - Interruption Handling (дзвінки, Siri тощо)
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
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            // Дзвінок почався — ставимо на паузу
            if playerState == .playing {
                player?.pause()
                playerState = .paused
            }
        case .ended:
            // Дзвінок завершився — продовжуємо якщо треба
            if let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    player?.play()
                    playerState = .playing
                }
            }
        @unknown default:
            break
        }
    }

    // MARK: - Remote Command Center
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextTrack()
            return .success
        }

        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousTrack()
            return .success
        }

        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self?.seek(to: event.positionTime)
            return .success
        }
    }

    // MARK: - Play
    func play(track: Track?, from playlist: [Track] = []) {
        guard let newTrack = track else { return }

        // Якщо той самий трек — toggle
        if let current = currentTrack, current.id == newTrack.id {
            togglePlayPause()
            return
        }

        if !playlist.isEmpty {
            self.playlist = playlist
            self.originalPlaylist = playlist
            if let index = playlist.firstIndex(where: { $0.id == newTrack.id }) {
                currentTrackIndex = index
            }
        } else if self.playlist.isEmpty {
            self.playlist = [newTrack]
            self.originalPlaylist = [newTrack]
            currentTrackIndex = 0
        } else if let index = self.playlist.firstIndex(where: { $0.id == newTrack.id }) {
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
            print("Invalid URL: \(track.title)")
            return
        }

        // Зупиняємо поточний плеєр
        player?.pause()
        removeTimeObserver()
        currentItemObservation?.invalidate()

        currentTrack = track
        playerState = .loading

        if sheetState == .hidden {
            sheetState = .mini
        }

        // Створюємо AVQueuePlayer з поточним треком
        let currentItem = AVPlayerItem(url: audioURL)
        player = AVQueuePlayer(playerItem: currentItem)

        // Префетчінг наступного треку
        preloadNextTrack()

        // Спостерігаємо за автоматичною зміною currentItem (коли AVQueuePlayer сам переходить)
        currentItemChangeObservation?.invalidate()
        currentItemChangeObservation = player?.observe(\.currentItem, options: [.new, .old]) { [weak self] _, change in
            guard let self = self else { return }
            // Спрацьовує тільки коли AVQueuePlayer сам перейшов на наступний трек
            guard change.oldValue != nil, let newItem = change.newValue as? AVPlayerItem else { return }
            DispatchQueue.main.async {
                // Знаходимо трек який відповідає новому item
                let nextIndex = self.currentTrackIndex + 1
                if nextIndex < self.playlist.count {
                    self.currentTrackIndex = nextIndex
                    self.currentTrack = self.playlist[nextIndex]
                    self.duration = self.playlist[nextIndex].durationInSeconds
                    self.currentTime = 0
                    self.setupNowPlayingInfo(for: self.playlist[nextIndex])
                    self.preloadNextTrack()
                }
            }
        }

        // KVO через observe — правильний спосіб
        currentItemObservation = currentItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                switch item.status {
                case .readyToPlay:
                    self?.player?.play()
                    self?.playerState = .playing
                case .failed:
                    self?.playerState = .stopped
                    self?.errorMessage = item.error?.localizedDescription ?? "Не вдалось завантажити трек"
                case .unknown:
                    self?.playerState = .loading
                @unknown default:
                    break
                }
            }
        }

        duration = track.durationInSeconds
        currentTime = 0

        addTimeObserver()
        setupNowPlayingInfo(for: track)
        observePlaybackEnd()
    }

    // Підвантаження наступного треку заздалегідь
    private func preloadNextTrack() {
        let nextIndex = currentTrackIndex + 1
        guard nextIndex < playlist.count,
              let nextURL = playlist[nextIndex].audioURL else { return }

        let nextItem = AVPlayerItem(url: nextURL)
        player?.insert(nextItem, after: player?.items().last)
    }

    // MARK: - Controls
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
        // Haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

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
        // Haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if currentTime > 3.0 {
            seek(to: 0)
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

    // MARK: - Shuffle (через індекси, без втрати позиції)
    func toggleShuffle() {
        isShuffleEnabled.toggle()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if isShuffleEnabled {
            var indices = Array(originalPlaylist.indices)
            if let currentIndex = originalPlaylist.firstIndex(where: { $0.id == currentTrack?.id }) {
                indices.removeAll { $0 == currentIndex }
                indices.shuffle()
                shuffledIndices = [currentIndex] + indices
            } else {
                indices.shuffle()
                shuffledIndices = indices
            }
            playlist = shuffledIndices.map { originalPlaylist[$0] }
            currentTrackIndex = 0
        } else {
            playlist = originalPlaylist
            if let currentTrack = currentTrack,
               let originalIndex = originalPlaylist.firstIndex(where: { $0.id == currentTrack.id }) {
                currentTrackIndex = originalIndex
            }
        }

        // Перебудовуємо чергу AVQueuePlayer щоб вона збігалась з новим playlist
        rebuildQueue()
    }

    // Синхронізація черги AVQueuePlayer з поточним playlist
    private func rebuildQueue() {
        guard let player = player else { return }

        // Видаляємо всі треки крім поточного
        let currentItem = player.currentItem
        player.items().forEach { item in
            if item != currentItem {
                player.remove(item)
            }
        }

        // Додаємо наступний трек в чергу
        preloadNextTrack()
    }

    func toggleRepeat() {
        switch repeatMode {
        case .off: repeatMode = .all
        case .all: repeatMode = .one
        case .one: repeatMode = .off
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    // MARK: - Sheet
    func showFullPlayer() { sheetState = .full }
    func hidePlayer() { sheetState = .hidden }
    func dismissPlayer() {
        sheetState = .hidden
        player?.pause()
        playerState = .stopped
        removeTimeObserver()
    }

    // MARK: - Seek
    // Виклик під час перетягування слайдера — тільки оновлює UI без seek
    func updateSeekTime(_ time: TimeInterval) {
        currentTime = time
    }

    // Виклик коли відпустив палець — робить справжній seek з максимальною точністю
    func seek(to time: TimeInterval) {
        guard !isSeeking else { return }
        isSeeking = true
        let cmTime = CMTime(seconds: time, preferredTimescale: 1000)
        // toleranceBefore/After .zero — максимальна точність, без стрибків
        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            self?.isSeeking = false
            self?.updateNowPlayingPlaybackRate()
        }
        currentTime = time
    }

    // MARK: - Now Playing Info
    private func setupNowPlayingInfo(for track: Track) {
        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = track.title
        info[MPMediaItemPropertyArtist] = track.artistName
        info[MPMediaItemPropertyAlbumTitle] = track.albumTitle
        info[MPMediaItemPropertyPlaybackDuration] = track.durationInSeconds
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info

        loadArtworkImageAsync(for: track) { image in
            guard let image = image else { return }
            var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }

    private func updateNowPlayingPlaybackRate() {
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        info[MPNowPlayingInfoPropertyPlaybackRate] = playerState == .playing ? 1.0 : 0.0
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    // MARK: - Artwork (NSCache)
    private func loadArtworkImageAsync(for track: Track, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: String(track.id))

        if let cached = artworkCache.object(forKey: cacheKey) {
            completion(cached)
            return
        }

        guard let url = URL(string: track.album.image) else {
            completion(getPlaceholderImage())
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self?.artworkCache.setObject(image, forKey: cacheKey)
                DispatchQueue.main.async { completion(image) }
            } else {
                DispatchQueue.main.async { completion(self?.getPlaceholderImage()) }
            }
        }
    }

    private func getPlaceholderImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 200, weight: .light)
        return UIImage(systemName: "music.note", withConfiguration: config)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
    }

    // MARK: - Time Observer
    private func addTimeObserver() {
        guard let player = player else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
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

    // MARK: - Helpers
    func isPlaying(track: Track) -> Bool {
        currentTrack?.id == track.id && playerState == .playing
    }

    func isPaused(track: Track) -> Bool {
        currentTrack?.id == track.id && playerState == .paused
    }

    func isCurrentTrack(_ track: Track) -> Bool {
        currentTrack?.id == track.id
    }

    func isPlaying(trackSlug: String) -> Bool {
        currentTrack?.slug == trackSlug && playerState == .playing
    }

    // MARK: - Deinit
    deinit {
        removeTimeObserver()
        currentItemObservation?.invalidate()
        currentItemChangeObservation?.invalidate()
        NotificationCenter.default.removeObserver(self)

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = false
        commandCenter.pauseCommand.isEnabled = false
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
        commandCenter.changePlaybackPositionCommand.isEnabled = false
    }
}
