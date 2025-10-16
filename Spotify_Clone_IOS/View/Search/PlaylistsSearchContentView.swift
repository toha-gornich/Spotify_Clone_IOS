//
//  PlaylistsSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct PlaylistsSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [Playlist] {
        if maxItems6 {
            Array(searchVM.playlists.prefix(6))
        } else {
            Array(searchVM.playlists)
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
                let sObj = limitedItems[index] // ✅ Використовуйте limitedItems замість searchVM.playlists
                NavigationLink(destination: PlaylistView(slugPlaylist: sObj.slug)
                    .environmentObject(mainVM)
                    .environmentObject(playerManager)
                ) {
                    MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                }
            }
        }
        .padding(.bottom, CGFloat(padding))
    }
}
