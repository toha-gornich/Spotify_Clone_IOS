//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI
struct AlbumView: View {
    let slugAlbum: String
    @StateObject private var albumVM = AlbumViewModel()
    @EnvironmentObject var router: Router
    @EnvironmentObject var playerManager: AudioPlayerManager
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false

    private let imageHeight: CGFloat = 300

    private var albumColor: Color {
        let colorString = albumVM.album.color
        if !colorString.isEmpty { return Color(hex: colorString) }
        return Color.bg
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.bg.ignoresSafeArea()

            // 1. Герой реагує на scrollOffset
            ScrollableHeroView(
                imageURL: albumVM.album.image,
                color: albumColor,
                imageHeight: imageHeight,
                scrollOffset: scrollOffset
            )
            .zIndex(0)

            // 2. Навігаційний бар
            DetailNavBar(title: albumVM.album.title, showTitle: showTitleInNavBar, backgroundColor: .bg) {
                PlayButton(track: albumVM.tracks.first, tracks: albumVM.tracks, showTitleInNavBar: showTitleInNavBar)
            }
            .zIndex(2)

            // 3. Скролований контент
            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: imageHeight - 20)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(albumVM.album.title)
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .opacity(showTitleInNavBar ? 0 : 1)

                            LazyVStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 12) {
                                    SpotifyRemoteImage(urlString: albumVM.album.artist.image)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 4) {
                                            Circle().fill(Color.gray).frame(width: 6, height: 6)
                                            Text(albumVM.tracks.count > 1 ? "Album" : "Single")
                                                .font(.caption).foregroundColor(.gray)

                                            Button { router.navigateTo(AppRoute.artist(slugArtist: albumVM.album.artist.slug)) } label: {
                                                Text(albumVM.album.artist.displayName)
                                                    .font(.subheadline).foregroundColor(.white)
                                            }
                                        }
                                        Text("\(albumVM.album.releaseDate.prefix(4)) • \(albumVM.totalDuration)")
                                            .font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                }

                                HStack(spacing: 16) {
                                    FavoriteButton(isLiked: albumVM.isAlbumLiked, isLoading: albumVM.isLoading) {
                                        albumVM.isAlbumLiked
                                            ? albumVM.deleteAlbumFavorite(slug: slugAlbum)
                                            : albumVM.postAlbumFavorite(slug: slugAlbum)
                                    }
                                    Spacer()
                                    PlayButton(track: albumVM.tracks.first, tracks: albumVM.tracks, showTitleInNavBar: !showTitleInNavBar)
                                        .scaleEffect(1.2)
                                }

                                TrackListView(tracks: albumVM.tracks)
                                    .task(id: albumVM.album.slug) {
                                        if !albumVM.album.slug.isEmpty {
                                            albumVM.getTracksBySlugAlbum(slug: albumVM.album.slug)
                                        }
                                    }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(albumVM.album.releaseDate).font(.caption).foregroundColor(.gray)
                                    Text("© \(albumVM.album.releaseDate.prefix(4)) \(albumVM.album.artist.displayName)").font(.caption).foregroundColor(.gray)
                                    Text("℗ \(albumVM.album.releaseDate.prefix(4)) \(albumVM.album.artist.displayName)").font(.caption).foregroundColor(.gray)
                                }

                                if !albumVM.album.artist.displayName.isEmpty {
                                    ViewAllSection(title: "More by \(albumVM.album.artist.displayName)") {}
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(albumVM.tracksByArtist.indices, id: \.self) { index in
                                            let sObj = albumVM.tracksByArtist[index]
                                            Button { router.navigateTo(AppRoute.artist(slugArtist: sObj.slug)) } label: {
                                                MediaItemCell(imageURL: sObj.album.image, title: sObj.title, width: 140, height: 140)
                                            }
                                        }
                                    }
                                }
                                .onChange(of: albumVM.album.slug) { newSlug in
                                    if !newSlug.isEmpty { albumVM.getTracksBySlugArtist(slug: albumVM.album.artist.slug) }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                            .padding(.bottom, 150)
                        }
                        .background(
                            VStack(spacing: 0) {
                                LinearGradient(
                                    colors: [albumColor.opacity(0.6), Color.bg],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 400)
                                Color.bg
                            }
                            .offset(y: -20)
                            .ignoresSafeArea(.all, edges: .horizontal)
                        )
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
        .task { albumVM.getAlbumBySlug(slug: slugAlbum) }
    }

    private func updateScrollOffset(_ offset: CGFloat) {
        let threshold: CGFloat = -imageHeight + 80
        if (offset < threshold) != showTitleInNavBar {
            withAnimation(.easeInOut(duration: 0.2)) {
                showTitleInNavBar.toggle()
            }
        }
    }
}
