//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI

struct ArtistView: View {
    @State var slugArtist: String
    @StateObject private var artistVM = ArtistViewModel()
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var router: Router
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false

    private let imageHeight: CGFloat = 300

    private var artistColor: Color {
        let colorString = artistVM.artist.color
        if !colorString.isEmpty { return Color(hex: colorString) }
        return Color.bg
    }

    private var overlayOpacity: CGFloat {
        scrollOffset < -50 ? min(abs(scrollOffset + 50) / 100, 1.0) : 0
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.bg.ignoresSafeArea()
            ScrollableHeroView(
                imageURL: artistVM.artist.image,
                color: artistColor,
                imageHeight: imageHeight,
                scrollOffset: scrollOffset
            )
            .zIndex(0)

            
            DetailNavBar(
                title: artistVM.artist.displayName,
                showTitle: showTitleInNavBar,
                backgroundColor: artistColor
            ) {
                PlayButton(track: artistVM.tracks.first, tracks: artistVM.tracks, showTitleInNavBar: showTitleInNavBar)
            }
            .zIndex(2)

            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {

                        Color.clear.frame(height: imageHeight - 20)

                        VStack(alignment: .leading, spacing: 12) {

                            Text(artistVM.artist.displayName)
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .opacity(showTitleInNavBar ? 0 : 1)

                            LazyVStack(alignment: .leading, spacing: 16) {
                                Text("3 007 212 355 listeners")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                HStack(spacing: 16) {
                                    // Follow / Following 
                                    Button(action: {
                                        artistVM.isFollowing
                                            ? artistVM.unfollowArtist(slug: artistVM.artist.slug)
                                            : artistVM.followArtist(slug: artistVM.artist.slug)
                                    }) {
                                        Text(artistVM.isFollowing ? "Following" : "Follow")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(artistVM.isFollowing ? .green : .white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .stroke(artistVM.isFollowing ? Color.green : Color.gray, lineWidth: 1)
                                            )
                                    }
                                    .disabled(artistVM.isLoading)

                                    Spacer()

                                    PlayButton(track: artistVM.tracks.first, tracks: artistVM.tracks, showTitleInNavBar: !showTitleInNavBar)
                                        .scaleEffect(1.2)
                                }

                                VStack(spacing: 20) {
                                    ViewAllSection(title: "Popular") {}
                                    LazyVStack(spacing: 0) {
                                        ForEach(0..<min(4, artistVM.tracks.count), id: \.self) { index in
                                            let sObj = artistVM.tracks[index]
                                            Button { router.navigateTo(AppRoute.track(slugTrack: sObj.slug)) } label: {
                                                TrackRowCell(track: sObj, index: index + 1)
                                            }
                                            if index < artistVM.tracks.count - 1 {
                                                Divider().background(Color.gray.opacity(0.2)).padding(.leading, 82)
                                            }
                                        }
                                    }
                                }
                                .task { artistVM.getTracksBySlugArtist(slug: slugArtist) }

                                ViewAllSection(title: "Albums") {}
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(artistVM.albums.indices, id: \.self) { index in
                                            let sObj = artistVM.albums[index]
                                            Button { router.navigateTo(AppRoute.album(slugAlbum: sObj.slug)) } label: {
                                                MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                                            }
                                        }
                                    }
                                }
                                .task { artistVM.getAlbumsBySlugArtist(slug: slugArtist) }

                                ViewAllSection(title: "Popular releases") {}
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(artistVM.tracks.indices.reversed(), id: \.self) { index in
                                            let sObj = artistVM.tracks[index]
                                            Button { router.navigateTo(AppRoute.track(slugTrack: sObj.slug)) } label: {
                                                MediaItemCell(imageURL: sObj.album.image, title: sObj.title, width: 140, height: 140)
                                            }
                                        }
                                    }
                                }

                                ViewAllSection(title: "Fans also like") {}
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(artistVM.artists.indices, id: \.self) { index in
                                            let sObj = artistVM.artists[index]
                                            Button { router.navigateTo(AppRoute.artist(slugArtist: sObj.slug)) } label: {
                                                ArtistItemView(artist: sObj)
                                            }
                                        }
                                    }
                                    .padding(.bottom, 100)
                                }
                                .task { artistVM.getArtists() }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                        }
                        .background(
                            VStack(spacing: 0) {
                                LinearGradient(
                                    colors: [artistColor.opacity(0.6), Color.bg],
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
        .task { artistVM.getArtistsBySlug(slug: slugArtist) }
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
