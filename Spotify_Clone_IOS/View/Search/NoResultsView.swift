//
//  NoResultsView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 22.09.2025.
//


import SwiftUI

struct NoResultsView: View {
    let type: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.primaryText.opacity(0.3))
                .padding(.top, 40)
            
            Text("No \(type) found")
                .font(.customFont(.medium, fontSize: 16))
                .foregroundColor(.primaryText)
            
            Text("Try adjusting your search terms")
                .font(.customFont(.regular, fontSize: 14))
                .foregroundColor(.primaryText.opacity(0.7))
        }
    }
}