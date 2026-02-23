//
//  DetailNavBar.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 23.02.2026.
//


import SwiftUI

struct DetailNavBar<TrailingContent: View>: View {
    let title: String
    let showTitle: Bool
    let backgroundColor: Color
    @ViewBuilder let trailingContent: () -> TrailingContent

    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
                Text(showTitle ? title : "")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(showTitle ? 1 : 0)
                Spacer()
                trailingContent()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .frame(height: 44)
            .background(backgroundColor.opacity(showTitle ? 1 : 0))
            Spacer()
        }
        .zIndex(2)
    }
}


