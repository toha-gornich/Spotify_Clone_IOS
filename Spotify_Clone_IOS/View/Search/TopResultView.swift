//
//  TopResultView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//

import SwiftUI

struct TopResultView: View {
    let track: Track
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    var body: some View {
        NavigationLink(destination: TrackView(slugTrack: track.slug).environmentObject(mainVM)
            .environmentObject(playerManager)){
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: track.album.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)
                
                // Song info
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.customFont(.bold, fontSize: 16))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("Song")
                            .font(.customFont(.regular, fontSize: 14))
                            .foregroundColor(.gray)
                        
                        Text("•")
                            .font(.customFont(.regular, fontSize: 14))
                            .foregroundColor(.gray)
                        
                        Text(track.artist.displayName)
                            .font(.customFont(.regular, fontSize: 14))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Play button
                Button(action: {
                    // Play action
                    print("Play")
                }) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .offset(x: 1) // Slight offset for visual balance
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.lightBg)
            .cornerRadius(8)
        }
    }
}
