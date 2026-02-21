//
//  TrackListView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 11.07.2025.
//

import SwiftUI
import SwiftUI

struct TrackListView: View {
    let tracks: [Track]
    let onMoreOptions: ((Int) -> Void)?
    let onDeleteTrack: ((String) async -> Void)?
    
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var router: Router
    
    @State private var showingDeleteAlert = false
    @State private var trackToDelete: Track?
    
    init(
        tracks: [Track],
        onMoreOptions: ((Int) -> Void)? = nil,
        onDeleteTrack: ((String) async -> Void)? = nil
    ) {
        self.tracks = tracks
        self.onMoreOptions = onMoreOptions
        self.onDeleteTrack = onDeleteTrack
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Vertical list for all tracks
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
                
                ForEach(0..<tracks.count, id: \.self) { index in
                    let sObj = tracks[index]
                    HStack(spacing: 12) {
                        // Track number
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(width: 20, alignment: .leading)
                        
                        // Track info
                        VStack(alignment: .leading, spacing: 2) {
                            
                            Button(){
                                router.navigateTo(AppRoute.track(slugTrack: sObj.slug))
                            }label: {
                                Text(tracks[index].title)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            
                            Button(){
                                router.navigateTo(AppRoute.artist(slugArtist: sObj.artist.slug))
                            }label: {
                                Text(tracks[index].artist.displayName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        // Duration
                        Text(tracks[index].formattedDuration)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // More options button with menu
                        Menu {
                            if onDeleteTrack != nil {
                                Button(role: .destructive, action: {
                                    trackToDelete = tracks[index]
                                    showingDeleteAlert = true
                                }) {
                                    Label("Remove from Playlist", systemImage: "trash")
                                }
                            }
                            
                            // Call custom handler if provided
                            if onMoreOptions != nil {
                                Button(action: {
                                    onMoreOptions?(index)
                                }) {
                                    Label("More Options", systemImage: "ellipsis.circle")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 30)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Track separator
                    if index < tracks.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                            .padding(.leading, 32)
                    }
                }
            }
        }
        .alert("Remove Track", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                trackToDelete = nil
            }
            Button("Remove", role: .destructive) {
                if let track = trackToDelete {
                    Task {
                        await onDeleteTrack?(track.slug)
                        trackToDelete = nil
                    }
                }
            }
        } message: {
            if let track = trackToDelete {
                Text("Are you sure you want to remove '\(track.title)' from this playlist?")
            }
        }
    }
}
