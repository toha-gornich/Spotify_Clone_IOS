//
//  TrackItemView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI

struct TrackCell: View {
    @State var track: Track
    
    var body: some View {
        NavigationLink(destination: TrackView(slugTrack: track.slug)) {
            HStack {
                
                SpotifyRemoteImage(urlString: track.album.image)
                    .frame(width: 60, height: 60)
                Text(track.slug)
                    .font(.customFont(.bold, fontSize: 13))
                    .foregroundColor(.primaryText)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                
            }
            .background(Color.elementBg)
            .cornerRadius(8)
            
            
        }
    }
        
}

#Preview {
    TrackCell(track: MockData.track)
}
