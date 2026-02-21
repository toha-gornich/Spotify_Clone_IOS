//
//  TabButtonAccount.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 14.09.2025.
//

import SwiftUI

struct TabButtonAccount: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Group {
                        if isSelected {
                            Capsule()
                                .stroke(Color.gray, lineWidth: 2)
                        } else {
                            Color.clear
                        }
                    }
                )
        }
    }
}
