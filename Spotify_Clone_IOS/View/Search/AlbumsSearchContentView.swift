//
//  AlbumsSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct AlbumsSearchContentView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    @ObservedObject var searchVM: SearchViewModel
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [Album] {
        if maxItems6{
            Array(searchVM.albums.prefix(6))
        }else {
            Array(searchVM.albums)
        }
        
    }
    
    init(searchVM: SearchViewModel, maxItems6: Bool = false, padding: Int = 70) {
        self.searchVM = searchVM
        self.maxItems6 = maxItems6
        self.padding = padding
    }
    
    var body: some View {
        
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(0..<limitedItems.count, id: \.self) { index in
                    let sObj = searchVM.albums[index]
                    NavigationLink(destination: AlbumView(slugAlbum: sObj.slug).environmentObject(mainVM)
                        .environmentObject(playerManager)
) {
                        MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                    }
                }
                
            }
            .padding(.bottom, CGFloat(padding))
    }
}
