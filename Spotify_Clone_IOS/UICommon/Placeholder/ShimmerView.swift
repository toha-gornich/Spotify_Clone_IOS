//
//  ShimmerView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.02.2026.
//

import SwiftUI

struct ShimmerView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let phase = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.2) / 1.2
            
            LinearGradient(
                colors: [
                    Color.gray.opacity(0.2),
                    Color.gray.opacity(0.4),
                    Color.gray.opacity(0.2)
                ],
                startPoint: UnitPoint(x: phase - 0.5, y: 0),
                endPoint: UnitPoint(x: phase + 0.5, y: 0)
            )
        }
    }
}

#Preview {
    ShimmerView()
}
