//
//  MenuItemView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.09.2025.
//

import SwiftUI

struct MenuItemView: View {
    let icon: String
    let title: String
    let action: (() -> Void)?
    
    
    init(icon: String, title: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}
