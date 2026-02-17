//
//  MyPlaylist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI
import PhotosUI

struct MyPlaylistView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var playlistVM = MyPlaylistViewModel()
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var mainVM: MainViewModel
    
    @State var slugPlaylist: String = ""
    @State private var searchText: String = ""
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitleInNavBar = false
    
    // Menu states
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
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
            
            // Fixed background with gradient
            VStack {
                ZStack {
                    // Gradient background
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
                    
                    // Playlist image placeholder
                    ZStack {
                        if !playlistVM.playlist.image.isEmpty {
                            SpotifyRemoteImage(urlString: playlistVM.playlist.image)
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(playlistColor.opacity(0.3))
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "music.note")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
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
                    
                    Text(playlistVM.playlist.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(showTitleInNavBar ? 1 : 0)
                    
                    Spacer()
                    
                    // Three dots menu
                    Menu {
                        Button(action: {
                            showingEditSheet = true
                        }) {
                            Label("Edit Playlist", systemImage: "pencil")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive, action: {
                            showingDeleteAlert = true
                        }) {
                            Label("Delete Playlist", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
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
                        
                        // Title section
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
                            
                            // User info
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(playlistVM.playlist.user.displayName?.prefix(1) ?? "M"))
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    )
                                
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
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            // Action buttons
                            HStack(spacing: 16) {
                                
                                // Privacy indicator
                                if playlistVM.playlist.isPrivate ?? true {
                                    HStack(spacing: 4) {
                                        Image(systemName: "lock.fill")
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                        Text("Private")
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(12)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if let tracks = playlistVM.playlist.tracks, !tracks.isEmpty {
                                        playerManager.play(track: tracks[0], from: tracks)
                                    }
                                }) {
                                    Image(systemName: playerManager.playerState == .playing ? "pause.fill" : "play.fill")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                        .frame(width: 44, height: 44)
                                        .background((playlistVM.playlist.tracks?.isEmpty ?? true) ? Color.gray.opacity(0.3) : Color.green)
                                        .clipShape(Circle())
                                }
                                .disabled(playlistVM.playlist.tracks?.isEmpty ?? true)
                                .opacity(showTitleInNavBar ? 0 : 1)
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.3))
                            
                            // Search section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Let's find something for your playlist")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                // Search Bar
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.white)
                                    
                                    TextField("Search...", text: $searchText)
                                        .foregroundColor(.white)
                                        .onChange(of: searchText) { newValue in
                                            playlistVM.searchTracks(searchText: newValue)
                                        }
                                    
                                    if !searchText.isEmpty {
                                        Button(action: {
                                            searchText = ""
                                            playlistVM.clearSearch()
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(12)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                
                                // Search Results
                                if playlistVM.isSearching {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .padding(.vertical, 40)
                                        Spacer()
                                    }
                                } else if !playlistVM.searchResults.isEmpty {
                                    // Show search results with add/remove functionality
                                    ForEach(Array(playlistVM.searchResults.prefix(10))) { track in
                                        SearchTrackRow(
                                            track: track,
                                            isInPlaylist: playlistVM.isTrackInPlaylist(track.slug),
                                            onToggle: {
                                                if playlistVM.isTrackInPlaylist(track.slug) {
                                                    return await playlistVM.removeTrack(track.slug)
                                                } else {
                                                    return await playlistVM.addTrack(track.slug)
                                                }
                                            }
                                        )
                                    }
                                } else if !searchText.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "music.note")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                        
                                        Text("No tracks found")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                }
                            }
                        }
                        .background(Color.bg)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        
                        // Track list - only if tracks exist
                        if let tracks = playlistVM.playlist.tracks, !tracks.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Divider()
                                    .background(Color.gray.opacity(0.3))
                                    .padding(.horizontal, 16)
                                
                                Text("Playlist tracks")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                
                                TrackListView(
                                    tracks: tracks,
                                    onDeleteTrack: { trackSlug in
                                        _ = await playlistVM.removeTrack(trackSlug)
                                    }
                                )
                                .padding(.bottom, 50)
                                .padding(.horizontal)
                                .environmentObject(playerManager)
                                .environmentObject(mainVM)
                            }
                            .padding(.top, 16)
                        }
                    }
                    .padding(.bottom, 80)
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
        
        .onAppear{
            mainVM.isTabBarVisible = false
        }
        .task {
             playlistVM.getPlaylist(slugPlaylist)
        }
        .sheet(isPresented: $showingEditSheet) {
            EditPlaylistSheet(
                playlist: playlistVM.playlist,
                onSave: { updatedTitle, updatedDescription, isPrivate, imageData in
                    Task {
                         _ = await playlistVM.patchPlaylist(
                             title: updatedTitle,
                             description: updatedDescription,
                             isPrivate: isPrivate,
                             imageData: imageData
                         )
                        // Refresh playlist to show updates
                        playlistVM.getPlaylist(slugPlaylist)
                    }
                }
            )
        }
        .alert("Delete Playlist", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await playlistVM.deletePlaylist()
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this playlist? This action cannot be undone.")
        }
        .navigationBarHidden(true)
    }
    
    private func updateScrollOffset(_ offset: CGFloat) {
        scrollOffset = offset
        
        let shouldShow = offset < -imageHeight + 30
        
        if shouldShow != showTitleInNavBar {
            showTitleInNavBar = shouldShow
        }
    }
}


