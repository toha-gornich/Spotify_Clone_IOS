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

    private let imageHeight: CGFloat = 300

    var body: some View {
        ZStack(alignment: .top) {
            Color.bg.ignoresSafeArea()

            // Hero image — reacts to scroll offset (stretches on pull-down)
            ScrollableHeroView(
                imageURL: trackVM.track.album.image,
                color: albumColor,
                imageHeight: imageHeight,
                scrollOffset: scrollOffset
            )
            .zIndex(0)

            //Navigation bar — fades in title when image scrolls out of view
            DetailNavBar(title: trackVM.track.title, showTitle: showTitleInNavBar, backgroundColor: .bg) {
                PlayButton(
                    track: trackVM.track.toTrack(),
                    tracks: [trackVM.track.toTrack()] + trackVM.tracks.filter { $0.id != trackVM.track.id },
                    showTitleInNavBar: showTitleInNavBar
                )
            }
            .zIndex(2)

            // 3. Scrollable content sits on top of hero
            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Transparent spacer so hero image is visible beneath
                        Color.clear.frame(height: imageHeight - 20)

                        // Main content with gradient background blending into hero
                        mainContentSection
                    }
                    .background(
                        ScrollOffsetReader(outerGeometry: outerGeometry) { offset in
                            self.scrollOffset = offset
                            updateScrollOffset(offset)
                        }
                    )
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

    // Main content block with gradient background transitioning from artist color to bg
    private var mainContentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleSection
            artistInfoSection
            actionButtonsSection
            recommendedSection
            artistPopularSection
            footerSection
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 150)
        .background(
            VStack(spacing: 0) {
                // Gradient fades from artist color into background
                LinearGradient(
                    colors: [albumColor.opacity(0.6), Color.bg],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 400)
                Color.bg
            }
            .offset(y: -20) // Overlap hero edge for seamless blend
            .ignoresSafeArea(.all, edges: .horizontal)
        )
    }

    // Track title — hidden once nav bar title is visible
    private var titleSection: some View {
        HStack {
            Text(trackVM.track.title)
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.white)
                .opacity(showTitleInNavBar ? 0 : 1)
            Spacer()
        }
    }

    // Artist avatar, name, duration and play count
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

    // Like button on the left, play button on the right
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            FavoriteButton(isLiked: trackVM.isTrackLiked, isLoading: trackVM.isLoading) {
                trackVM.isTrackLiked
                    ? trackVM.deleteTrackFavorite(slug: slugTrack)
                    : trackVM.postTrackFavorite(slug: slugTrack)
            }
            Spacer()
            PlayButton(
                track: trackVM.track.toTrack(),
                tracks: [trackVM.track.toTrack()] + trackVM.tracks,
                showTitleInNavBar: !showTitleInNavBar
            )
            .scaleEffect(1.2)
        }
    }

    // Up to 5 genre-based recommended tracks
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

    // Up to 5 popular tracks by the same artist
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

    // Release date and copyright info
    private var footerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(trackVM.track.formattedCreatedDate).font(.caption).foregroundColor(.gray)
            Text("© \(trackVM.track.createdAt?.prefix(4) ?? "") \(trackVM.track.artist.displayName)").font(.caption).foregroundColor(.gray)
        }
    }
}

// MARK: - Logic Helpers
extension TrackView {

    // Derives artist color from track's album; falls back to default bg color
    private var albumColor: Color {
        let colorString = trackVM.track.album.color
        return colorString.isEmpty ? Color.bg : Color(hex: colorString)
    }

    // Updates scroll position and toggles nav bar title visibility
    private func updateScrollOffset(_ offset: CGFloat) {
        let threshold: CGFloat = -imageHeight + 80
        if (offset < threshold) != showTitleInNavBar {
            withAnimation(.easeInOut(duration: 0.2)) {
                showTitleInNavBar.toggle()
            }
        }
    }

    // Loads track data, then starts playback if this track isn't already playing
    private func loadTrackAndPlay() async {
        await trackVM.getTrackBySlug(slug: slugTrack)

        if !trackVM.track.genre.slug.isEmpty {
            await trackVM.getTracksBySlugGenre(slug: trackVM.track.genre.slug)
        }

        let trackToPlay = trackVM.track.toTrack()

        // Skip playback setup if this track is already active
        if playerManager.currentTrack?.id == trackToPlay.id { return }

        let filteredRecommendations = trackVM.tracks.filter { $0.id != trackToPlay.id }
        let fullQueue = [trackToPlay] + filteredRecommendations

        playerManager.play(track: trackToPlay, from: fullQueue)
    }
}
