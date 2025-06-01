//
//  AsyncImageView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.05.2025.
//

import SwiftUI

struct AsyncImageView: View {
    let imageURL: String
    let width: CGFloat?
    let height: CGFloat?
    
    init(_ imageURL: String, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.imageURL = imageURL
        self.width = width
        self.height = height
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
            case .failure(_):
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .frame(width: width, height: height)
            case .empty:
                ProgressView()
                    .frame(width: width, height: height)
            @unknown default:
                EmptyView()
            }
        }
    }
}


#Preview {
    AsyncImageView("http://192.168.0.110:8080/mediafiles/artists/artist2/ab6761610000e5eb214f3cf1cbe7139c1e26ffbb.jpg",width: 100, height: 100)
}
