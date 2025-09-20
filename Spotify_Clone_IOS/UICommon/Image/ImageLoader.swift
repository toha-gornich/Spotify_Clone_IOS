//
//  ImageLoader.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import SwiftUI


final class ImageLoader: ObservableObject{
    
    @Published var image: Image? = nil
    func load(fromURLString urlString: String) {
        
        
        NetworkManager.shared.downloadImage(fromURLString: urlString) { uiImage in
            if let uiImage = uiImage {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            } else {
                print("Image upload error")
            }
        }
    }
}

struct RemoteImage: View {
    var image: Image?
    var body: some View{
        image?.resizable() ?? Image("img_3").resizable()
    }
}

struct SpotifyRemoteImage: View {
    @StateObject var imageLoader = ImageLoader()
    let urlString: String

    var body: some View {
        RemoteImage(image: imageLoader.image)
            .onAppear {
                if !urlString.isEmpty {
                    imageLoader.load(fromURLString: urlString)
                }
            }
            .onChange(of: urlString) { newURL in
                if !newURL.isEmpty {
                    imageLoader.load(fromURLString: newURL)
                }
            }
    }
}
