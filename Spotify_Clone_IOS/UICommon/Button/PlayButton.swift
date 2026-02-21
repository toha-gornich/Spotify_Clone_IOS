//
//  PlayButton.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.02.2026.
//

import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var playerManager: AudioPlayerManager
    let track: Track?
    let tracks: [Track]?
    let showTitleInNavBar: Bool
    
    var body: some View {
        Button(action: {
            guard let track = track, let tracks = tracks else { return }
            playerManager.play(track: track, from: tracks)
        }) {
            if let track = track {
                Image(systemName: playerManager.isPlaying(track: track) ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.green)
                    .clipShape(Circle())
            } else {
                Image(systemName: "play.fill")
                    .font(.title3)
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.green)
                    .clipShape(Circle())
            }
        }
        .opacity(showTitleInNavBar ? 1 : 0)
        .disabled(track == nil)
    }
}

//
//#Preview {
//    PlayButton()
//}
