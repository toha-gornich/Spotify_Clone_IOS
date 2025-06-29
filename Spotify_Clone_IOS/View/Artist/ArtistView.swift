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
                    
                    Color.clear.frame(width: 44)
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
                                // Play button
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
                                
                                
                            }
                            
                            
                            
                            
                            VStack(spacing: 20) {
                                // Заголовок для треків
                                HStack {
                                    Text("Popular")
                                        .font(.customFont(.bold, fontSize: 20))
                                        .foregroundColor(.primaryText)
                                    Spacer()
                                }
                                
                                
                                
                                // Вертикальний список для всіх треків
                                LazyVStack(spacing: 0) {
                                    ForEach(0..<artistVM.tracks.count, id: \.self) { index in
                                        TrackRowCell(
                                            track: artistVM.tracks[index],
                                            index: index + 1
                                        )
                                        
                                        // Роздільник між треками
                                        if index < artistVM.tracks.count - 1 {
                                            Divider()
                                                .background(Color.gray.opacity(0.2))
                                                .padding(.leading, 82)
                                        }
                                    }
                                }
                            }
                            .task {
                                artistVM.getTracks()
                            }
                            
                            
                            ForEach(0..<20, id: \.self) { index in
                                HStack {
                                    Text("Content \(index + 1)")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                .padding(.vertical, 16)
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
        print("Current scroll offset: \(offset), overlay opacity: \(overlayOpacity)")
        
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
