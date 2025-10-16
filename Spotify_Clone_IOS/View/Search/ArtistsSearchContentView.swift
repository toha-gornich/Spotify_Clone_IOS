//
//  ArtistsSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct ArtistsSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [Artist] {
        if maxItems6{
            Array(searchVM.artists.prefix(6))
        }else {
            Array(searchVM.artists)
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
                    let sObj = searchVM.artists[index]
                    NavigationLink(destination: ArtistView(slugArtist: sObj.slug).environmentObject(mainVM)
                        .environmentObject(playerManager)
) {
                        ArtistItemView(artist: sObj)
                    }
                }
                
            }
            .padding(.bottom, CGFloat(padding))

        
    }
}
