//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI
struct ArtistView: View {
    let slugArtist: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var artistVM = ArtistViewModel()
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false
    
    private let imageHeight: CGFloat = 200
    
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
                    SpotifyRemoteImage(urlString: artistVM.artist.image)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: imageHeight)
                    
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
                    
                    Text(showTitleInNavBar ? artistVM.artist.displayName : "")
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
                .padding(.top, 8)
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
                                Text(artistVM.artist.displayName)
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
                            
                            Text("3 007 212 355 listeners")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            
                            HStack(spacing: 16) {
                                
                                // Add button
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
                                
                                // Follow button
                                Button(action: {
                                    // Follow action
                                }) {
                                    Text("Follow")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                                Spacer()
                                // Play button (this one will hide when scrolled)
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
                                // Title for tracks
                                ViewAllSection(title: "Popular") {}
                                
                                
                                // Vertical list for all tracks by slug artist
                                LazyVStack(spacing: 0) {
                                    ForEach(0..<min(4,artistVM.tracks.count), id: \.self) { index in
                                        TrackRowCell(
                                            track: artistVM.tracks[index],
                                            index: index + 1
                                        )
                                        
                                        // Track separator
                                        if index < artistVM.tracks.count - 1 {
                                            Divider()
                                                .background(Color.gray.opacity(0.2))
                                                .padding(.leading, 82)
                                        }
                                    }
                                }
                            }
                            .task {
                                artistVM.getTracksBySlugArtist(slug: slugArtist)
                            }
                            
                            // Title for albums
                            ViewAllSection(title: "Albums") {}
                            
                            // Vertical list for all albums by slug artist
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(artistVM.albums.indices, id: \.self) { index in
                                        let sObj = artistVM.albums[index]
                                        MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                                    }
                                }
                            }
                            .task {
                                artistVM.getAlbumsBySlugArtist(slug: slugArtist)
                            }
                            
                            
                            // Title for popular releases
                            ViewAllSection(title: "Popular releases") {}
                            
                            // Vertical list for popular releases by slug artist
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(artistVM.tracks.indices.reversed(), id: \.self) { index in
                                        let sObj = artistVM.tracks[index]
                                        MediaItemCell(imageURL: sObj.album.image, title: sObj.title, width: 140, height: 140)
                                    }
                                }
                            }

                            // Title for popular releases
                            ViewAllSection(title: "Fans also like") {}
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(artistVM.artists.indices, id: \.self) { index in
                                        
                                        let sObj = artistVM.artists[index]
                                        
                                        NavigationLink(destination: ArtistView(slugArtist: sObj.slug)) {
                                            VStack {
                                                SpotifyRemoteImage(urlString: sObj.image)
                                                    .frame(width: 140, height: 140)
                                                    .clipShape(Circle())
                                                
                                                Text(sObj.displayName)
                                                    .font(.customFont(.bold, fontSize: 13))
                                                    .foregroundColor(.primaryText)
                                                    .lineLimit(2)
                                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 100)
                            }
                            .task {
                                artistVM.getArtists()
                            }
                            
                        }
                        .background(Color.bg)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
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
            artistVM.getArtistsBySlug(slug: slugArtist)
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
