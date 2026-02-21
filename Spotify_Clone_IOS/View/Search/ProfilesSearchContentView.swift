//
//  ProfilesSearchContentView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct ProfilesSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var playerManager: AudioPlayerManager
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [User] {
        if maxItems6 {
            Array(searchVM.profiles.prefix(6))
        } else {
            Array(searchVM.profiles)
        }
    }
    
    init(searchVM: SearchViewModel, maxItems6: Bool = false, padding: Int = 70) {
        self.searchVM = searchVM
        self.maxItems6 = maxItems6
        self.padding = padding
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(limitedItems) { user in
                    Button(){
                        router.navigateTo(AppRoute.profile(profileId: String(user.id)))
                    }label: {
                        ArtistItemView(user: user)
                    }
                }
            }
            .padding(.horizontal, 1) 
        }
    }
}
