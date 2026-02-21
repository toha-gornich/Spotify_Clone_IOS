//
//  TrackItemView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI

struct TrackCell: View {
    @State var track: Track
    @EnvironmentObject var router:Router
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        Button(){
            router.navigateTo(AppRoute.track(slugTrack: track.slug))
        }label: {
            HStack {
                
                SpotifyRemoteImage(urlString: track.album.image)
                    .frame(width: 60, height: 60)
                Text(track.title)
                    .font(.customFont(.bold, fontSize: 13))
                    .foregroundColor(.primaryText)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                
            }
            .background(Color.elementBg)
            .cornerRadius(8)
        }.buttonStyle(PlainButtonStyle())
    }
        
}
