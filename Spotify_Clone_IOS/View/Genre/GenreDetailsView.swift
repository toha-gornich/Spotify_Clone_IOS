//
//  GenreDetails.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 27.07.2025.
//

import SwiftUI

struct GenreDetailsView: View {
    let slugGenre: String
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var genresVM: GenresViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false
    
    private let imageHeight: CGFloat = 100
    
    // Album color computed property
    private var genreColor: Color {
        let colorString = genresVM.genre.color
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
                            genreColor.opacity(0.8),
                            genreColor.opacity(0.4),
                            Color.bg
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
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
            
            // Back button with blur circle
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            // Blur circle background (appears on scroll)
                            Circle()
                                .fill(.gray)
                                .opacity(showTitleInNavBar ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3), value: showTitleInNavBar)
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        .frame(width: 44, height: 44)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 8)
                    
                    Spacer()
                }
                
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
                                Text(genresVM.genre.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Content section with gradient background
                        ZStack {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        genreColor.opacity(0.1),
                                        Color.bg.opacity(0.8),
                                        Color.bg
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                
                                // Additional radial gradient for a more interesting effect
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        genreColor.opacity(0.05),
                                        Color.clear
                                    ]),
                                    center: .topLeading,
                                    startRadius: 50,
                                    endRadius: 200
                                )
                            }
                            .frame(maxWidth: .infinity)
                            
                            LazyVStack(alignment: .leading, spacing: 16) {
                                if !genresVM.tracks.isEmpty {
                                    ViewAllSection(title: "Popular \(genresVM.genre.name) tracks") {}
                                    TrackListViewImage(tracks: Array(genresVM.tracks.prefix(5)))
                                        .environmentObject(mainVM)
                                        .environmentObject(playerManager)
                                }
                                
                                if !genresVM.playlists.isEmpty {
                                    Text("Popular \(genresVM.genre.name) playlists")
                                        .font(.customFont(.bold, fontSize: 18))
                                        .foregroundColor(.primaryText)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 15) {
                                            ForEach(genresVM.playlists.indices, id: \.self) { index in
                                                let sObj = genresVM.playlists[index]
                                                NavigationLink(destination: PlaylistView(slugPlaylist: sObj.slug)
                                                    .environmentObject(mainVM)
                                                    .environmentObject(playerManager)) {
                                                    MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // Повідомлення коли немає контенту
                                if genresVM.tracks.isEmpty && genresVM.playlists.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "music.note")
                                            .font(.system(size: 48))
                                            .foregroundColor(.gray)
                                            .opacity(0.6)
                                        
                                        Text("No content available")
                                            .font(.customFont(.medium, fontSize: 18))
                                            .foregroundColor(.secondaryText)
                                        
                                        Text("Check back later for new tracks and playlists")
                                            .font(.customFont(.regular, fontSize: 14))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.top, 60)
                                }
                            }
                            .padding(.horizontal, 16)
                            .task {
                                genresVM.getTracksBySlugGenre(slug: slugGenre)
                                genresVM.getPlaylistsBySlugGenre(slug: slugGenre)
                            }
                        }
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
            genresVM.getGenreBySlug(slug: slugGenre)
        }
        .onAppear {
            mainVM.isTabBarVisible = false
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
