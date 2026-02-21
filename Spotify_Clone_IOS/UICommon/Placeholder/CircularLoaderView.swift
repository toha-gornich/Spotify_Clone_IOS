//
//  Placeholder.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.02.2026.
//

import SwiftUI

struct CircularLoaderView: View {
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 140, height: 140)
            .overlay(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            )
    }
}

#Preview {
    CircularLoaderView()
}
