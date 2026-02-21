//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI
struct PlaylistView: View {
    let slugPlaylist: String
    @StateObject  var playlistVM = PlaylistViewModel()
    @EnvironmentObject var playerManager: AudioPlayerManager
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false
    
    private let imageHeight: CGFloat = 250
    
    // Playlist color computed property
    private var playlistColor: Color {
        let colorString = playlistVM.playlist.color
        if !colorString.isEmpty {
            return Color(hex: colorString)
        }
        return Color.bg
    }
    
    // Calculate overlay opacity based on scroll offset
    private var overlayOpacity: CGFloat {
        let fadeThreshold: CGFloat = 50
        let maxFade: CGFloat = 150
        
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
                            playlistColor.opacity(0.8),
                            playlistColor.opacity(0.4),
                            Color.bg
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(maxWidth: .infinity, maxHeight: imageHeight + 100)
                    
                    SpotifyRemoteImage(urlString: playlistVM.playlist.image)
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
                    BackButton()
                    
                    Spacer()
                    
                    Text(showTitleInNavBar ? playlistVM.playlist.title : "")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(showTitleInNavBar ? 1 : 0)
                    
                    Spacer()
                    
                    PlayButton(
                        track: playlistVM.tracks.first,
                        tracks: playlistVM.tracks,
                        showTitleInNavBar: showTitleInNavBar
                    )
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
                                Text(playlistVM.playlist.title)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .opacity(showTitleInNavBar ? 0 : 1)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Content section
                        LazyVStack(alignment: .leading, spacing: 16) {
                            
                            // Playlist description - only if exists and not empty
                            if let description = playlistVM.playlist.description, !description.isEmpty {
                                Text(description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            // Playlist genre
                            if let genreName = playlistVM.playlist.genre?.name {
                                Text(genreName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 12) {
                                // User image
                                SpotifyRemoteImage(urlString: playlistVM.playlist.user.image ?? "")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                            Text(playlistVM.playlist.user.displayName ?? "Unknown")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 6, height: 6)
                                            
                                            Text("\(playlistVM.playlist.favoriteCount ?? 0) saves")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 6, height: 6)
                                            
                                            Text("\(playlistVM.playlist.tracks?.count ?? 0) songs")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                            if let tracks = playlistVM.playlist.tracks, !tracks.isEmpty {
                                                Circle()
                                                    .fill(Color.gray)
                                                    .frame(width: 6, height: 6)
                                                
                                                Text(playlistVM.totalDuration)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    if playlistVM.isPlaylistLiked {
                                        playlistVM.deletePlaylistFavorite(slug: slugPlaylist)
                                    } else {
                                        playlistVM.postPlaylistFavorite(slug: slugPlaylist)
                                    }
                                }) {
                                    Image(systemName: playlistVM.isPlaylistLiked ? "checkmark" : "plus")
                                        .font(.title2)
                                        .foregroundColor(playlistVM.isPlaylistLiked ? .green : .white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.clear)
                                        .overlay(
                                            Circle()
                                                .stroke(playlistVM.isPlaylistLiked ? Color.green : Color.gray, lineWidth: 1)
                                        )
                                }
                                .disabled(playlistVM.isLoading)
                                
                                Spacer()
                                
                                PlayButton(
                                    track: playlistVM.tracks.first,
                                    tracks: playlistVM.tracks,
                                    showTitleInNavBar: !showTitleInNavBar
                                )
                            }
                            
                            // Track list - only if tracks exist
                            if let tracks = playlistVM.playlist.tracks {
                                TrackListView(tracks: tracks)
                                    .environmentObject(playerManager)
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
            playlistVM.getPlaylistBySlug(slug: slugPlaylist)
        }
    }
    
    private func updateScrollOffset(_ offset: CGFloat) {
        scrollOffset = offset
        
        let shouldShow = offset < -imageHeight + 30
        
        if shouldShow != showTitleInNavBar {
            showTitleInNavBar = shouldShow
        }
    }
}
