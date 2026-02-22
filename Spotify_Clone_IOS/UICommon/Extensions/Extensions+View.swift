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


extension View {
    func swipeBack(router: Router) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onEnded { gesture in
                    // Check if the gesture started near the left edge (within 40 points)
                    let isStartingAtEdge = gesture.startLocation.x < 40
                    
                    // Check if the swipe distance is sufficient
                    let isFarEnough = gesture.translation.width > 80
                    
                    // Check swipe velocity (so even a short but fast swipe works)
                    let isFastEnough = gesture.predictedEndLocation.x - gesture.location.x > 50
                    
                    if isStartingAtEdge && (isFarEnough || isFastEnough) {
                        // Add light haptic feedback to mimic native gesture feel
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                        
                        router.goBack()
                    }
                }
        )
    }
}


extension View {
    func hideKeyboard() -> some View {
        simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    }
}

extension View{
    func cornerRadius(_ radius: CGFloat, corner: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corner: corner))
    }
}
