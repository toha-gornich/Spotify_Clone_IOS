//
//  TabButtonLibrary.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 26.10.2025.
//


import SwiftUI

struct TabButtonLibrary: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.customFont(.medium, fontSize: 14))
                .foregroundColor(isSelected ? .primaryText : .secondaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected ? Color.primaryText.opacity(0.15) : Color.clear
                )
                .cornerRadius(16)
        }
    }
}