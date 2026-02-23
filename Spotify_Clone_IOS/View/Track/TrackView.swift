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

    private var albumColor: Color {
        let colorString = trackVM.track.album.color
        if !colorString.isEmpty { return Color(hex: colorString) }
        return Color.bg
    }

    private var overlayOpacity: CGFloat {
        scrollOffset < -50 ? min(abs(scrollOffset + 50) / 100, 1.0) : 0
    }

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()

            ScrollableHeroView(imageURL: trackVM.track.album.image, color: albumColor, imageHeight: imageHeight, overlayOpacity: overlayOpacity)

            DetailNavBar(title: trackVM.track.title, showTitle: showTitleInNavBar, backgroundColor: .bg) {
                PlayButton(track: trackVM.tracks.first, tracks: trackVM.tracks, showTitleInNavBar: showTitleInNavBar)
            }

            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: imageHeight)

                        HStack {
                            Text(trackVM.track.title)
                                .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                                .opacity(showTitleInNavBar ? 0 : 1)
                            Spacer()
                        }
                        .padding(.horizontal, 16)

                        LazyVStack(alignment: .leading, spacing: 20) {
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
                                        Circle().fill(Color.gray).frame(width: 6, height: 6)
                                        Button { router.navigateTo(AppRoute.album(slugAlbum: trackVM.track.album.slug)) } label: {
                                            Text(trackVM.track.album.title).font(.subheadline).foregroundColor(.white)
                                        }
                                    }
                                    HStack(spacing: 4) {
                                        Circle().fill(Color.gray).frame(width: 6, height: 6)
                                        Text(String(trackVM.track.createdAt?.prefix(4) ?? "")).font(.subheadline).foregroundColor(.gray)
                                        Circle().fill(Color.gray).frame(width: 6, height: 6)
                                        Text(trackVM.track.formattedDuration).font(.subheadline).foregroundColor(.gray)
                                        Circle().fill(Color.gray).frame(width: 6, height: 6)
                                        Text(trackVM.track.playsCount, format: .number.grouping(.automatic)).font(.subheadline).foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                            }

                            HStack(spacing: 16) {
                                FavoriteButton(isLiked: trackVM.isTrackLiked, isLoading: trackVM.isLoading) {
                                    trackVM.isTrackLiked ? trackVM.deleteTrackFavorite(slug: slugTrack) : trackVM.postTrackFavorite(slug: slugTrack)
                                }
                                Spacer()
                                PlayButton(track: trackVM.tracks.first, tracks: trackVM.tracks, showTitleInNavBar: !showTitleInNavBar)
                            }

                            VStack(alignment: .leading) {
                                Text("Recommended").font(.customFont(.bold, fontSize: 18)).foregroundColor(.primaryText).frame(maxWidth: .infinity, alignment: .leading)
                                Text("Based on what's in this track").font(.subheadline).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                                TrackListView(tracks: Array(trackVM.tracks.prefix(5)))
                                    .environmentObject(playerManager)
                                    .task(id: trackVM.track.genre.slug) {
                                        if !trackVM.track.genre.slug.isEmpty { trackVM.getTracksBySlugGenre(slug: trackVM.track.genre.slug) }
                                    }
                            }

                            VStack(alignment: .leading) {
                                Text("Popular Tracks by").font(.subheadline).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                                Text(trackVM.track.artist.displayName).font(.customFont(.bold, fontSize: 18)).foregroundColor(.primaryText).frame(maxWidth: .infinity, alignment: .leading)
                                TrackListViewImage(tracks: Array(trackVM.tracksByArtist.prefix(5)))
                                    .environmentObject(playerManager)
                                    .task(id: trackVM.track.artist.slug) {
                                        if !trackVM.track.artist.slug.isEmpty { trackVM.getTrackBySlugArtist(slug: trackVM.track.artist.slug) }
                                    }
                            }

                            VStack(alignment: .leading) {
                                Text("Popular Albums by").font(.subheadline).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                                Text(trackVM.track.artist.displayName).font(.customFont(.bold, fontSize: 18)).foregroundColor(.primaryText).frame(maxWidth: .infinity, alignment: .leading)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(trackVM.albums.indices, id: \.self) { index in
                                            let sObj = trackVM.albums[index]
                                            Button { router.navigateTo(AppRoute.album(slugAlbum: sObj.slug)) } label: {
                                                MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                                            }
                                        }
                                    }
                                }
                                .task(id: trackVM.track.artist.slug) {
                                    if !trackVM.track.artist.slug.isEmpty { trackVM.getAlbumsBySlugArtist(slug: trackVM.track.artist.slug) }
                                }
                            }

                            VStack {
                                ViewAllSection(title: "Fans also like") {}
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(trackVM.artists.indices, id: \.self) { index in
                                            let sObj = trackVM.artists[index]
                                            Button { router.navigateTo(AppRoute.artist(slugArtist: sObj.slug)) } label: {
                                                ArtistItemView(artist: sObj)
                                            }
                                        }
                                    }
                                }
                                .task { trackVM.getArtists() }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(String(trackVM.track.formattedCreatedDate)).font(.caption).foregroundColor(.gray)
                                Text("© \(trackVM.track.createdAt?.prefix(4) ?? "") \(trackVM.track.artist.displayName)").font(.caption).foregroundColor(.gray)
                                Text("℗ \(trackVM.track.createdAt?.prefix(4) ?? "") \(trackVM.track.artist.displayName)").font(.caption).foregroundColor(.gray)
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
        .task { await trackVM.getTrackBySlug(slug: slugTrack) }
    }

    private func updateScrollOffset(_ offset: CGFloat) {
        scrollOffset = offset
        let shouldShow = offset < -imageHeight + 30
        if shouldShow != showTitleInNavBar { showTitleInNavBar = shouldShow }
    }
}
