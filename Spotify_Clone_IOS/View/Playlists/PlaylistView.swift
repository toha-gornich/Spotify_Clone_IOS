//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI
struct PlaylistView: View {
    let slugPlaylist: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var playlistVM = PlaylistViewModel()
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
                    
                    Text(showTitleInNavBar ? playlistVM.playlist.title : "")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(showTitleInNavBar ? 1 : 0)
                    
                    Spacer()
                    
                    // Play button in navigation bar
                    Button(action: {
                        // Play action
                    }) {
                        Image(systemName: "play.fill")
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
                            
                            // Artist info section
                            HStack(spacing: 12) {
                                // Artist image
                                SpotifyRemoteImage(urlString: playlistVM.artist.image)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 8) {
                                        // Artist indicator
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 6, height: 6)
                                            
                                            Text("Artist")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        // Artist name
                                        Text(playlistVM.artist.displayName)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                    
                                    // Listeners count
                                    Text("3 007 212 355 listeners")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    // Add action
                                }) {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.clear)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                                
                                Spacer()
                                
                                
                                Button(action: {
                                    // Play action
                                }) {
                                    Image(systemName: "play.fill")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .frame(width: 56, height: 56)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                                .opacity(showTitleInNavBar ? 0 : 1)
                                
                            }
                            
                            VStack(spacing: 20) {
                                // Vertical list for all tracks by slug artist
                                LazyVStack(spacing: 0) {
                                    // Header row
                                    HStack(spacing: 12) {
                                        // # column
                                        Text("#")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .frame(width: 20, alignment: .leading)
                                        
                                        // Title column
                                        Text("Title")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        // Time column with clock icon
                                        HStack(spacing: 4) {
                                            Image(systemName: "clock")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        // Space for more options button
                                        Spacer()
                                            .frame(width: 20)
                                    }
                                    .padding(.vertical, 8)
                                    
                                    // Header separator line
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                        .padding(.bottom, 8)
                                    
                                    ForEach(0..<playlistVM.playlist.tracks.count, id: \.self) { index in
                                        HStack(spacing: 12) {
                                            // Track number
                                            Text("\(index + 1)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .frame(width: 20, alignment: .leading)
                                            
                                            // Track info
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(playlistVM.playlist.tracks[index].title)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                
                                                Text(playlistVM.playlist.tracks[index].artist.displayName)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                            }
                                            
                                            Spacer()
                                            
                                            // Duration
                                            Text(playlistVM.playlist.tracks[index].formattedDuration)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            
                                            // More options button
                                            Button(action: {
                                                // More options action
                                            }) {
                                                Image(systemName: "ellipsis")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.vertical, 8)
                                        
                                        // Track separator
                                        if index < playlistVM.playlist.tracks.count - 1 {
                                            Divider()
                                                .background(Color.gray.opacity(0.2))
                                                .padding(.leading, 32)
                                        }
                                    }
                                }
                            }
                            .task {
//                                playlistVM.getTracksBySlugArtist(slug: slugPlaylist)
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
        
        // Show navigation bar when scrolled down enough to cover the image
        let shouldShow = offset < -imageHeight + 30
        
        if shouldShow != showTitleInNavBar {
            showTitleInNavBar = shouldShow
        }
    }
}
#Preview {
    MainView()
    
}
