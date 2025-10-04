//
//  AnalyticsView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.09.2025.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Still Under Development")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("We are still working on this page. Please check back later for updates.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
        }.padding(.horizontal)
            .padding(.top, 20)
    }
}
