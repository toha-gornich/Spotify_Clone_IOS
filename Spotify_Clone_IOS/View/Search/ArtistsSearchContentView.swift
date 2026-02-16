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
let onLoadMore: (() -> Void)?
let isLoading: Bool

private var limitedItems: [Artist] {
    if maxItems6 {
        Array(searchVM.artists.prefix(6))
    } else {
        Array(searchVM.artists)
    }
}

init(
    searchVM: SearchViewModel,
    maxItems6: Bool = false,
    padding: Int = 70,
    onLoadMore: (() -> Void)? = nil,
    isLoading: Bool = false
) {
    self.searchVM = searchVM
    self.maxItems6 = maxItems6
    self.padding = padding
    self.onLoadMore = onLoadMore
    self.isLoading = isLoading
}

var body: some View {
    VStack {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 10) {
            ForEach(Array(limitedItems.enumerated()), id: \.offset) { index, artist in
                NavigationLink(destination: ArtistView(slugArtist: artist.slug)
                    .environmentObject(mainVM)
                    .environmentObject(playerManager)) {
                    ArtistItemView(artist: artist)
                }
                .onAppear {
                    if index == limitedItems.count - 2 && !maxItems6 {
                        onLoadMore?()
                    }
                }
            }
        }
        
        // Loading indicator
        if isLoading && !maxItems6 {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding()
        }
    }
    .padding(.bottom, CGFloat(padding))
}
}
