//
//  TrackListView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 11.07.2025.
//

import SwiftUI

struct TrackListView: View {
    let tracks: [Track]
    let onMoreOptions: ((Int) -> Void)?
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var mainVM: MainViewModel
    init(tracks: [Track], onMoreOptions: ((Int) -> Void)? = nil) {
        self.tracks = tracks
        self.onMoreOptions = onMoreOptions
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
                    HStack(spacing: 12) {
                        // Track number
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(width: 20, alignment: .leading)
                        
                        // Track info
                        VStack(alignment: .leading, spacing: 2) {
                            NavigationLink(destination: TrackView(slugTrack: tracks[index].slug).environmentObject(mainVM)
                                .environmentObject(playerManager)) {
                                Text(tracks[index].title)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            NavigationLink(destination: ArtistView(slugArtist: tracks[index].artist.slug).environmentObject(mainVM)
                                .environmentObject(playerManager)) {
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
                        
                        // More options button
                        Button(action: {
                            onMoreOptions?(index)
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.caption)
                                .foregroundColor(.gray)
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
    }
}

