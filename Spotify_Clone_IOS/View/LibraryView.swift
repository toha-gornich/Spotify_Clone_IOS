//
//  LibraryView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var mainVM: MainViewModel  
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                mainVM.isTabBarVisible = true
            }
//            .onDisappear {
//                mainVM.isTabBarVisible = false
//            }
    }
}

#Preview {
    LibraryView()
}
