//
//  TrackListView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 11.07.2025.
//

import SwiftUI
struct TrackListViewImage: View {
    let tracks: [Track]
    let onMoreOptions: ((Int) -> Void)?
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [Track] {
        if maxItems6 {
            return Array(tracks.prefix(6))
        } else {
            return Array(tracks)
        }
    }
    
    init(tracks: [Track], maxItems6: Bool = false, padding: Int = 100, onMoreOptions: ((Int) -> Void)? = nil) {
        self.tracks = tracks
        self.maxItems6 = maxItems6
        self.onMoreOptions = onMoreOptions
        self.padding = padding
    }
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVStack(spacing: 0) {
                // Header row
                HStack(spacing: 8) {
                    Text("#")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(width: 30, alignment: .leading)
                    
                    Text("Title")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Plays")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(width: 70, alignment: .trailing)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 50, alignment: .trailing)
                    
                    Spacer()
                        .frame(width: 30)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                
                ForEach(0..<limitedItems.count, id: \.self) { index in
                    HStack(spacing: 8) {
                        // Track number
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(width: 20, alignment: .leading)
                        
                        // Track info
                        NavigationLink(destination: TrackView(slugTrack: tracks[index].slug)) {
                            HStack(spacing: 8) {
                                SpotifyRemoteImage(urlString: tracks[index].album.image)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                
                                
                                Text(tracks[index].title)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Plays count
                        Text(tracks[index].formattedPlaysCount)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(width: 50, alignment: .trailing)
                        
                        // Duration
                        Text(tracks[index].formattedDuration)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(width: 50, alignment: .trailing)
                        
                        // More options
                        Button(action: {
                            onMoreOptions?(index)
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 30, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    
                    if index < tracks.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                            .padding(.horizontal, 12)
                            .padding(.leading, 44)
                    }
                }
            }
        }
    }
}
