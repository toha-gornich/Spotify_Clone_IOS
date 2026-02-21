//
//  AlbumsSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI
struct AlbumsSearchContentView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var playerManager: AudioPlayerManager
    @ObservedObject var searchVM: SearchViewModel
    let maxItems6: Bool
    let padding: Int
    let onLoadMore: (() -> Void)?
    let isLoading: Bool
    
    private var limitedItems: [Album] {
        if maxItems6 {
            Array(searchVM.albums.prefix(6))
        } else {
            Array(searchVM.albums)
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
                ForEach(Array(limitedItems.enumerated()), id: \.offset) { index, album in
                    Button(){
                        router.navigateTo(AppRoute.album(slugAlbum: album.slug))
                    }label: {
                        MediaItemCell(imageURL: album.image, title: album.title, width: 140, height: 140)
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
