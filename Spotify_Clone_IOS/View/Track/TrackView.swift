//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI
struct TrackView: View {
    let slugTrack: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var trackVM = TrackViewModel()
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false
    
    private let imageHeight: CGFloat = 250
    
    // Album color computed property
    private var albumColor: Color {
        let colorString = trackVM.album.color
        if !colorString.isEmpty {
            return Color(hex: colorString)
        }
        return Color.bg
    }
    
    // Calculate overlay opacity based on scroll offset
    private var overlayOpacity: CGFloat {
        let fadeThreshold: CGFloat = 50 // Start fading after scrolling 50 points
        let maxFade: CGFloat = 150 // Complete fade at 150 points
        
        if scrollOffset < -fadeThreshold {
            let fadeProgress = abs(scrollOffset + fadeThreshold) / (maxFade - fadeThreshold)
            return min(fadeProgress, 1.0)
        }
        return 0
    }
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            // Fixed background image with color overlay
            VStack {
                ZStack {
                    // Gradient background behind image
                    LinearGradient(
                        gradient: Gradient(colors: [
                            albumColor.opacity(0.8),
                            albumColor.opacity(0.4),
                            Color.bg
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(maxWidth: .infinity, maxHeight: imageHeight + 100)
                    
                    SpotifyRemoteImage(urlString: trackVM.track.album.image)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 250, maxHeight: imageHeight)
                        .padding(.top, 120)
                    
                    // Color overlay that gradually appears
                    Color.bg
                        .opacity(overlayOpacity)
                        .animation(.easeOut(duration: 0.1), value: overlayOpacity)
                }
                .frame(maxWidth: .infinity, maxHeight: imageHeight)
                
                
                Spacer()
            }
            .ignoresSafeArea()
            
            // Custom Navigation Bar overlay
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.bg)
                            )
                            .background(.ultraThinMaterial, in: Circle())
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text(showTitleInNavBar ? trackVM.track.title : "")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(showTitleInNavBar ? 1 : 0)
                    
                    Spacer()
                    
//                    PlayButton
                    Button(action: {
                        let trackToPlay = trackVM.playableTrack
                        playerManager.play(track: trackToPlay)
                    }) {
                        Image(systemName: playerManager.playerState == .playing ? "pause.fill" : "play.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                    .opacity(showTitleInNavBar ? 1 : 0)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                .frame(height: 44)
                .background(
                    Color.bg
                        .opacity(showTitleInNavBar ? 1 : 0)
                )
                
                
                Spacer()
            }
            .zIndex(2)
            
            // Main scrollable content
            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Transparent spacer to push content down
                        Color.clear
                            .frame(height: imageHeight)
                        
                        // Artist title section with gradient overlay
                        VStack {
                            HStack {
                                
                                Text(trackVM.track.title)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .opacity(showTitleInNavBar ? 0 : 1)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            
                            
                        }
                        
                        // Content section
                        LazyVStack(alignment: .leading, spacing: 20) {
                            
                            // Album info section
                            HStack(spacing: 12) {
                                // Artist image
                                SpotifyRemoteImage(urlString: trackVM.track.artist.image)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 8) {
                                        // Album/Single indicator
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 6, height: 6)
                                        }
                                        
                                        // Artist name
                                        NavigationLink(destination: ArtistView(slugArtist: trackVM.track.artist.slug).environmentObject(mainVM).environmentObject(playerManager)) {
                                            Text(trackVM.track.artist.displayName)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 6, height: 6)
                                        }
                                        
                                        NavigationLink(destination: AlbumView(slugAlbum: trackVM.track.album.slug).environmentObject(mainVM).environmentObject(playerManager)) {
                                            Text(trackVM.track.album.title)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                        
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 6, height: 6)
                                        
                                        Text(String(trackVM.track.createdAt?.prefix(4) ?? ""))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 6, height: 6)
                                        }
                                        Text(trackVM.track.formattedDuration)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 6, height: 6)
                                        }
                                        Text(trackVM.track.playsCount, format: .number.grouping(.automatic))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            
                            HStack(spacing: 16) {
                                
                                
                                Button(action: {
                                    if trackVM.isTrackLiked {
                                        trackVM.deleteTrackFavorite(slug: slugTrack)
                                    } else {
                                        trackVM.postTrackFavorite(slug: slugTrack)
                                    }
                                }) {
                                    Image(systemName: trackVM.isTrackLiked ? "checkmark" : "plus")
                                        .font(.title2)
                                        .foregroundColor(trackVM.isTrackLiked ? .green : .white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.clear)
                                        .overlay(
                                            Circle()
                                                .stroke(trackVM.isTrackLiked ? Color.green : Color.gray, lineWidth: 1)
                                        )
                                }
                                .disabled(trackVM.isLoading)
                                
                                Spacer()
                                Button(action: {
                                    let trackToPlay = trackVM.playableTrack
                                    playerManager.play(track: trackToPlay, from: trackVM.tracks)
                                }) {
                                    Image(systemName: playerManager.isPlaying(track: trackVM.playableTrack) ? "pause.fill" : "play.fill")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                        .frame(width: 44, height: 44)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                                .opacity(showTitleInNavBar ? 0 : 1)
                                
                            }
                            
                            // recomended Based on what's in this track
                            VStack {
                                Text("Recommended")
                                    .font(.customFont(.bold, fontSize: 18))
                                    .foregroundColor(.primaryText)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                Text("Based on what's in this track")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                TrackListView(tracks: Array(trackVM.tracks.prefix(5))).environmentObject(mainVM).environmentObject(playerManager)
                                    .task(id: trackVM.track.genre.slug) {
                                        if !trackVM.track.genre.slug.isEmpty {
                                            trackVM.getTracksBySlugGenre(slug: trackVM.track.genre.slug)
                                        }
                                    }
                            }
                            
                            // TPopular Tracks by Artist
                            VStack {
                                Text("Popular Tracks by")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                Text(trackVM.track.artist.displayName)
                                    .font(.customFont(.bold, fontSize: 18))
                                    .foregroundColor(.primaryText)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                TrackListViewImage(tracks: Array(trackVM.tracksByArtist.prefix(5))).environmentObject(mainVM).environmentObject(playerManager)
                                    .task(id: trackVM.track.artist.slug) {
                                        if !trackVM.track.artist.slug.isEmpty {
                                            trackVM.getTrackBySlugArtist(slug: trackVM.track.artist.slug)
                                        }
                                    }
                                
                            }
                            
                            // Popular Albums by Artist
                            VStack {
                                Text("Popular Albums by")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                Text(trackVM.track.artist.displayName)
                                    .font(.customFont(.bold, fontSize: 18))
                                    .foregroundColor(.primaryText)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(trackVM.albums.indices, id: \.self) { index in
                                            let sObj = trackVM.albums[index]
                                            NavigationLink(destination: AlbumView(slugAlbum: sObj.slug).environmentObject(mainVM).environmentObject(playerManager)) {
                                                MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                                            }
                                        }
                                    }
                                }
                                .task(id: trackVM.track.artist.slug) {
                                    if !trackVM.track.artist.slug.isEmpty {
                                        trackVM.getAlbumsBySlugArtist(slug: trackVM.track.artist.slug)
                                    }
                                }
                                
                            }
                            // Title for popular releases
                            VStack {
                                ViewAllSection(title: "Fans also like") {}
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(trackVM.artists.indices, id: \.self) { index in
                                            
                                            let sObj = trackVM.artists[index]
                                            
                                            NavigationLink(destination: ArtistView(slugArtist: sObj.slug).environmentObject(mainVM).environmentObject(playerManager)) {
                                                ArtistItemView(artist: sObj)
                                            }
                                        }
                                    }
                                }
                                .task {
                                    trackVM.getArtists()
                                }
                            }
                            
                            
                            
                            // Copyright information section
                            VStack(alignment: .leading, spacing: 4) {
                                // Release date
                                Text(String(trackVM.track.formattedCreatedDate))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                
                                VStack(alignment: .leading) {
                                    Text("© \(trackVM.track.createdAt?.prefix(4) ?? "") \(trackVM.track.artist.displayName)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("℗ \(trackVM.track.createdAt?.prefix(4) ?? "") \(trackVM.track.artist.displayName)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            
                        }
                        .background(Color.bg)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 150)
                    }
                    .background(
                        GeometryReader { scrollGeometry in
                            Color.clear
                                .onAppear {
                                    let offset = scrollGeometry.frame(in: .global).minY - outerGeometry.safeAreaInsets.top
                                    updateScrollOffset(offset)
                                }
                                .onChange(of: scrollGeometry.frame(in: .global).minY) { newValue in
                                    let offset = newValue - outerGeometry.safeAreaInsets.top
                                    updateScrollOffset(offset)
                                }
                        }
                    )
                }
            }
            .zIndex(1)
        }
        
        .navigationBarHidden(true)
        .task {
            trackVM.getTrackBySlug(slug: slugTrack)
            
        }
        .onAppear {
            mainVM.isTabBarVisible = false
            trackVM.postTrackFavorite(slug: slugTrack)
        }
        
    }
    private func updateScrollOffset(_ offset: CGFloat) {
        scrollOffset = offset
        
        // Show navigation bar when scrolled down enough to cover the image
        let shouldShow = offset < -imageHeight + 30
        
        if shouldShow != showTitleInNavBar {
            showTitleInNavBar = shouldShow
        }
    }
}
