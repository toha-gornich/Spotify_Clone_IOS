//
//  FavoriteButton.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 23.02.2026.
//


import SwiftUI

struct FavoriteButton: View {
    let isLiked: Bool
    let isLoading: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: isLiked ? "checkmark" : "plus")
                .font(.title2)
                .foregroundColor(isLiked ? .green : .white)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(isLiked ? Color.green : Color.gray, lineWidth: 1)
                )
        }
        .disabled(isLoading)
    }
}

