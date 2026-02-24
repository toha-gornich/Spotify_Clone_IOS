//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI

struct TrackView: View {
    @EnvironmentObject var router: Router
    let slugTrack: String
    @StateObject private var trackVM = TrackViewModel()
    @EnvironmentObject var playerManager: AudioPlayerManager
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false

    private let imageHeight: CGFloat = 250

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()

            ScrollableHeroView(imageURL: trackVM.track.album.image, color: albumColor, imageHeight: imageHeight, overlayOpacity: overlayOpacity)

            DetailNavBar(title: trackVM.track.title, showTitle: showTitleInNavBar, backgroundColor: .bg) {
                PlayButton(
                    track: trackVM.track.toTrack(),
                    tracks: [trackVM.track.toTrack()] + trackVM.tracks.filter { $0.id != trackVM.track.id },
                    showTitleInNavBar: showTitleInNavBar)
            }

            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: imageHeight)

                        mainContentSection
                    }
                    .background(ScrollOffsetReader(outerGeometry: outerGeometry) { updateScrollOffset($0) })
                }
            }
            .zIndex(1)
        }
        .navigationBarHidden(true)
        .swipeBack(router: router)
        .task {
            await loadTrackAndPlay()
        }
    }
}

// MARK: - Subviews
extension TrackView {
    
    private var mainContentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleSection
            artistInfoSection
            actionButtonsSection
            recommendedSection
            artistPopularSection
            footerSection
        }
        .background(Color.bg)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 150)
    }

    private var titleSection: some View {
        HStack {
            Text(trackVM.track.title)
                .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                .opacity(showTitleInNavBar ? 0 : 1)
            Spacer()
        }
    }

    private var artistInfoSection: some View {
        HStack(spacing: 12) {
            SpotifyRemoteImage(urlString: trackVM.track.artist.image)
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40).clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Circle().fill(Color.gray).frame(width: 6, height: 6)
                    Button { router.navigateTo(AppRoute.artist(slugArtist: trackVM.track.artist.slug)) } label: {
                        Text(trackVM.track.artist.displayName).font(.subheadline).foregroundColor(.white)
                    }
                }
                HStack(spacing: 4) {
                    Text(trackVM.track.formattedDuration).font(.subheadline).foregroundColor(.gray)
                    Circle().fill(Color.gray).frame(width: 6, height: 6)
                    Text("\(trackVM.track.playsCount) plays").font(.subheadline).foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            FavoriteButton(isLiked: trackVM.isTrackLiked, isLoading: trackVM.isLoading) {
                trackVM.isTrackLiked ? trackVM.deleteTrackFavorite(slug: slugTrack) : trackVM.postTrackFavorite(slug: slugTrack)
            }
            Spacer()
//            PlayButton(track: trackVM.tracks.first, tracks: trackVM.tracks, showTitleInNavBar: !showTitleInNavBar)
            // Виклик у Навбарі та в тілі екрана
            PlayButton(
                track: trackVM.track.toTrack(), // Передаємо сам цей трек
                tracks: [trackVM.track.toTrack()] + trackVM.tracks, // Формуємо чергу: цей трек + рекомендовані
                showTitleInNavBar: !showTitleInNavBar // або !showTitleInNavBar залежно від місця
            )
        }
    }

    private var recommendedSection: some View {
        VStack(alignment: .leading) {
            Text("Recommended").font(.headline).foregroundColor(.white)
            TrackListView(tracks: Array(trackVM.tracks.prefix(5)))
                .environmentObject(playerManager)
        }
        .task(id: trackVM.track.genre.slug) {
            if !trackVM.track.genre.slug.isEmpty {
                await trackVM.getTracksBySlugGenre(slug: trackVM.track.genre.slug)
            }
        }
    }

    private var artistPopularSection: some View {
        VStack(alignment: .leading) {
            Text("Popular by \(trackVM.track.artist.displayName)").font(.headline).foregroundColor(.white)
            TrackListViewImage(tracks: Array(trackVM.tracksByArtist.prefix(5)))
                .environmentObject(playerManager)
        }
        .task(id: trackVM.track.artist.slug) {
            if !trackVM.track.artist.slug.isEmpty {
                await trackVM.getTrackBySlugArtist(slug: trackVM.track.artist.slug)
            }
        }
    }

    private var footerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(trackVM.track.formattedCreatedDate).font(.caption).foregroundColor(.gray)
            Text("© \(trackVM.track.createdAt?.prefix(4) ?? "") \(trackVM.track.artist.displayName)").font(.caption).foregroundColor(.gray)
        }
    }
}

// MARK: - Logic Helpers
extension TrackView {
    private var albumColor: Color {
        let colorString = trackVM.track.album.color
        return colorString.isEmpty ? Color.bg : Color(hex: colorString)
    }

    private var overlayOpacity: CGFloat {
        scrollOffset < -50 ? min(abs(scrollOffset + 50) / 100, 1.0) : 0
    }

    private func updateScrollOffset(_ offset: CGFloat) {
        scrollOffset = offset
        let shouldShow = offset < -imageHeight + 30
        if shouldShow != showTitleInNavBar { showTitleInNavBar = shouldShow }
    }

    private func loadTrackAndPlay() async {
        // 1. Чекаємо на деталі треку
        await trackVM.getTrackBySlug(slug: slugTrack)
        
        // 2. ЯВНО ЧЕКАЄМО на рекомендації (тепер це можливо завдяки async)
        if !trackVM.track.genre.slug.isEmpty {
            await trackVM.getTracksBySlugGenre(slug: trackVM.track.genre.slug)
        }
        
        let trackToPlay = trackVM.track.toTrack()
        
        // Перевірка на "той самий трек"
        if playerManager.currentTrack?.id == trackToPlay.id { return }
        
        // 3. Формуємо чергу (поточний + завантажені рекомендації)
        // Фільтруємо, щоб не було дублікатів самого себе в списку
        let filteredRecommendations = trackVM.tracks.filter { $0.id != trackToPlay.id }
        let fullQueue = [trackToPlay] + filteredRecommendations
        
        playerManager.play(track: trackToPlay, from: fullQueue)
    }
}

