//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI

struct PlaylistView: View {
    let slugPlaylist: String
    @StateObject var playlistVM = PlaylistViewModel()
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var router: Router
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false

    private let imageHeight: CGFloat = 250

    private var playlistColor: Color {
        let colorString = playlistVM.playlist.color
        if !colorString.isEmpty { return Color(hex: colorString) }
        return Color.bg
    }

    private var overlayOpacity: CGFloat {
        scrollOffset < -50 ? min(abs(scrollOffset + 50) / 100, 1.0) : 0
    }

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()

            ScrollableHeroView(imageURL: playlistVM.playlist.image, color: playlistColor, imageHeight: imageHeight, overlayOpacity: overlayOpacity)

            DetailNavBar(title: playlistVM.playlist.title, showTitle: showTitleInNavBar, backgroundColor: .bg) {
                PlayButton(track: playlistVM.tracks.first, tracks: playlistVM.tracks, showTitleInNavBar: showTitleInNavBar)
            }

            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: imageHeight)

                        HStack {
                            Text(playlistVM.playlist.title)
                                .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                                .opacity(showTitleInNavBar ? 0 : 1)
                            Spacer()
                        }
                        .padding(.horizontal, 16)

                        LazyVStack(alignment: .leading, spacing: 16) {
                            if let description = playlistVM.playlist.description, !description.isEmpty {
                                Text(description).font(.caption).foregroundColor(.gray)
                            }

                            if let genreName = playlistVM.playlist.genre?.name {
                                Text(genreName).font(.title3).fontWeight(.bold).foregroundColor(.gray)
                            }

                            HStack(spacing: 12) {
                                SpotifyRemoteImage(urlString: playlistVM.playlist.user.image ?? "")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40).clipShape(Circle())

                                HStack(spacing: 4) {
                                    Text(playlistVM.playlist.user.displayName ?? "Unknown").font(.caption).foregroundColor(.white)
                                    Circle().fill(Color.gray).frame(width: 6, height: 6)
                                    Text("\(playlistVM.playlist.favoriteCount ?? 0) saves").font(.caption).foregroundColor(.white)
                                    Circle().fill(Color.gray).frame(width: 6, height: 6)
                                    Text("\(playlistVM.playlist.tracks?.count ?? 0) songs").font(.caption).foregroundColor(.white)
                                    if let tracks = playlistVM.playlist.tracks, !tracks.isEmpty {
                                        Circle().fill(Color.gray).frame(width: 6, height: 6)
                                        Text(playlistVM.totalDuration).font(.caption).foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                            }

                            HStack(spacing: 16) {
                                FavoriteButton(isLiked: playlistVM.isPlaylistLiked, isLoading: playlistVM.isLoading) {
                                    playlistVM.isPlaylistLiked ? playlistVM.deletePlaylistFavorite(slug: slugPlaylist) : playlistVM.postPlaylistFavorite(slug: slugPlaylist)
                                }
                                Spacer()
                                PlayButton(track: playlistVM.tracks.first, tracks: playlistVM.tracks, showTitleInNavBar: !showTitleInNavBar)
                            }

                            if let tracks = playlistVM.playlist.tracks {
                                TrackListView(tracks: tracks).environmentObject(playerManager)
                            }
                        }
                        .background(Color.bg)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 150)
                    }
                    .background(ScrollOffsetReader(outerGeometry: outerGeometry) { updateScrollOffset($0) })
                }
            }
            .zIndex(1)
        }
        .navigationBarHidden(true)
        .swipeBack(router: router)
        .task { playlistVM.getPlaylistBySlug(slug: slugPlaylist) }
    }

    private func updateScrollOffset(_ offset: CGFloat) {
        scrollOffset = offset
        let shouldShow = offset < -imageHeight + 30
        if shouldShow != showTitleInNavBar { showTitleInNavBar = shouldShow }
    }
}
