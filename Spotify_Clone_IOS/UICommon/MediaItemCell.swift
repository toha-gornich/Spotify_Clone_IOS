//
//  TrackTemplate.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI
import SwiftUI

struct MediaItemCell: View {
    let imageURL: String
    let title: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            SpotifyRemoteImage(urlString: imageURL)
                .frame(width: width, height: height)
                .padding(.bottom, 4)
            
            Text(title)
                .font(.customFont(.bold, fontSize: 13))
                .foregroundColor(.primaryText)
                .lineLimit(2)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}


#Preview {
    MediaItemCell(imageURL: "url", title: "title", width: 100, height: 100)
}

