//
//  Extensions+View.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 16.02.2026.
//

import SwiftUI

// Extension for placeholder functionality
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
