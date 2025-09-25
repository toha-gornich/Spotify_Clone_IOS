//
//  ProfilesSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct ProfilesSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            
            if searchVM.playlists.isEmpty {
                NoResultsView(type: "playlists")
            }
        }
    }
}
