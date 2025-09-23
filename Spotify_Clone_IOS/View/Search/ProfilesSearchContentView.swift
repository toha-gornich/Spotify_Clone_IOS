//
//  ProfilesSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct ProfilesSearchContentView: View {
    //    let searchText: String
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            //            ForEach(searchVM.playlists, id: \.id) { playlist in
            //                PlaylistRowView(playlist: playlist)
            //            }
            
            if searchVM.playlists.isEmpty {
                NoResultsView(type: "playlists")
            }
        }
    }
}