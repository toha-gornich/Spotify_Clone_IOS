//
//  ScrollOffsetReader.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 23.02.2026.
//


import SwiftUI

struct ScrollOffsetReader: View {
    let outerGeometry: GeometryProxy
    let onOffsetChange: (CGFloat) -> Void

    var body: some View {
        GeometryReader { scrollGeometry in
            Color.clear
                .onAppear {
                    let offset = scrollGeometry.frame(in: .global).minY - outerGeometry.safeAreaInsets.top
                    onOffsetChange(offset)
                }
                .onChange(of: scrollGeometry.frame(in: .global).minY) { newValue in
                    onOffsetChange(newValue - outerGeometry.safeAreaInsets.top)
                }
        }
    }
}


