//
//  TrackTemplate.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI

struct TrackTemplate: View {
    @State var tracksArr: [[String: String]] = []
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(tracksArr.indices, id: \.self) { index in
                    
                    let sObj = tracksArr[index]
                    
                    VStack {
                        AsyncImageView(sObj["image"] ?? "", width: 140, height: 140)
                            .padding(.bottom, 4)
                        
                        
                        Text(sObj["name"] ?? "")
                            .font(.customFont(.bold, fontSize: 13))
                            .foregroundColor(.primaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                    }
                }
            }
            
        }
        .padding(.vertical, 16)
        
    }
}

#Preview {
    TrackTemplate()
}
