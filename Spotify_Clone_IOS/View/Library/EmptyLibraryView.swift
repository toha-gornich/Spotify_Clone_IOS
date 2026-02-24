//
//  EmptyLibraryView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 16.02.2026.
//


import SwiftUI

struct EmptyLibraryView: View {
    let icon: String
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.secondaryText.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.customFont(.bold, fontSize: 20))
                    .foregroundColor(.primaryText)
                
                Text(subtitle)
                    .font(.customFont(.regular, fontSize: 14))
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.customFont(.medium, fontSize: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(20)
                }
                .padding(.top, 10)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .padding(.top, 50)
    }
}
