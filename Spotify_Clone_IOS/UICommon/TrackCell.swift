//
//  TrackItemView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI

struct TrackItemView: View {
    @State var item: [String: String]
    
    var body: some View {
        HStack {
            AsyncImageView(item["image"] ?? "", width: 70, height: 70)
            
            Text(item["name"] ?? "")
                .font(.customFont(.bold, fontSize: 13))
                .foregroundColor(.primaryText60)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            
        }
        .background(Color.darkGray)
        
            
    }
        
}

#Preview {
    TrackItemView(item: [
        "image": "http://192.168.0.110:8080/mediafiles/artists/artist2/ab6761610000e5eb214f3cf1cbe7139c1e26ffbb.jpg",
        "name": "Classic Playlist",
        "artists": "Piano Guys"
    ])
}
