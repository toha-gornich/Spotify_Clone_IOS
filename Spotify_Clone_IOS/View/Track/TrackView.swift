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
                    
                    Text(showTitleInNavBar ? trackVM.album.title : "")
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
                                
                                Text(trackVM.album.title)
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
                            
                            // Album info section
                            HStack(spacing: 12) {
                                // Artist image
                                SpotifyRemoteImage(urlString: trackVM.album.artist.image)
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
                                            
//                                            Text(trackVM.tracks.count > 1 ? "Album" : "Single")
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
                                        }
                                        
                                        // Artist name
                                        NavigationLink(destination: ArtistView(slugArtist: trackVM.album.artist.slug)) {
                                            Text(trackVM.album.artist.displayName)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    // Total duration
//                                    Text("\(trackVM.album.releaseDate.prefix(4)) • \(trackVM.totalDuration)")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            
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
                            
//                            TrackListView(tracks: trackVM.tracks)
                            .task(id: trackVM.album.slug) {
//                                if !trackVM.album.slug.isEmpty {
////                                    trackVM.getTracksBySlugAlbum(slug: trackVM.album.slug)
//                                }
                            }
                            
                            // Copyright information section
                            VStack(alignment: .leading, spacing: 4) {
                                // Release date
                                Text(trackVM.album.releaseDate)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                               
                                VStack(alignment: .leading) {
                                    Text("© \(trackVM.album.releaseDate.prefix(4)) \(trackVM.album.artist.displayName)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("℗ \(trackVM.album.releaseDate.prefix(4)) \(trackVM.album.artist.displayName)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
//                            .padding(.top, 24)
//                            .padding(.bottom, 16)
                            
                            // Title for albums
                            if !trackVM.album.artist.displayName.isEmpty {
                                ViewAllSection(title: "More by \(trackVM.album.artist.displayName)") {}
                            }
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(trackVM.tracksByArtist.indices, id: \.self) { index in
                                        
                                        let sObj = trackVM.tracksByArtist[index]
                                        
                                        VStack {
                                            if !sObj.artist.image.isEmpty {
                                                SpotifyRemoteImage(urlString: sObj.album.image)
                                                    .frame(width: 140, height: 140)
                                                    .clipShape(Circle())
                                            } else {
                                                // Placeholder під час завантаження
                                                Circle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 140, height: 140)
                                                    .overlay(
                                                        ProgressView()
                                                            .progressViewStyle(CircularProgressViewStyle())
                                                    )
                                            }
                                            
                                            Text(sObj.title)
                                                .font(.customFont(.bold, fontSize: 13))
                                                .foregroundColor(.primaryText)
                                                .lineLimit(2)
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                            .onChange(of: trackVM.album.slug) { newSlug in
//                                if !newSlug.isEmpty {
//                                    print(trackVM.album.artist.displayName)
//                                    trackVM.getTracksBySlugArtist(slug: trackVM.album.artist.slug)
//                                }
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
