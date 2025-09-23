//
//  EmptySearchView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.primaryText.opacity(0.3))
                .padding(.top, 60)
            
            Text("Start typing to search...")
                .foregroundColor(.primaryText.opacity(0.7))
                .font(.customFont(.regular, fontSize: 16))
            
            Text("Find your favorite songs, artists, albums and playlists")
                .foregroundColor(.primaryText.opacity(0.5))
                .font(.customFont(.regular, fontSize: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}