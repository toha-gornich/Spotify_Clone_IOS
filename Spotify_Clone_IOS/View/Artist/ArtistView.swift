//
//  ArtistView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 06.06.2025.
//

import SwiftUI

struct ArtistView: View {
    let slugArtist: String
    @StateObject private var artistVM = ArtistViewModel()
    
    var body: some View {
        VStack {
            ScrollView{
                Text(artistVM.artist.displayName)
                
            }
            .task {
                
                artistVM.getArtistsBySlug(slug: slugArtist)
            }
            
        }
        .background(Color.bg)
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainView()
        
}
