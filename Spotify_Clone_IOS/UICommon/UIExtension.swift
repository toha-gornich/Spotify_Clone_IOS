//
//  UIExtension.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.05.2025.
//


import SwiftUI

enum CircularStd:String {
    case regular = "CircularStd-Book"
    case medium = "CircularStd-Medium"
    case bold = "CircularStd-Bold"
    case black = "CircularStd-Black"
    
}

extension Font {
    static func customFont(_ font: CircularStd, fontSize: CGFloat) -> Font {
        Font.custom(font.rawValue, size: fontSize)
    }
}

extension CGFloat {
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
    }
    
    static var topInsets: Double {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return 0.0 }
        return window.safeAreaInsets.top
    }
    
    static var bottomInsets: Double {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return 0.0 }
        return window.safeAreaInsets.bottom
    }
    
    static var horizontalInsets: Double {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return 0.0 }
        return window.safeAreaInsets.left + window.safeAreaInsets.right
    }
    
    static var verticalInsets: Double {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return 0.0 }
        return window.safeAreaInsets.top + window.safeAreaInsets.bottom
    }
}

extension Color{
    static var primaryApp: Color {
        return Color(hex: "C35BD1")
    }
    static var focus: Color {
        return Color(hex: "D9519D")
    }
    static var unfocused: Color {
        return Color(hex: "63666E")
    }
    static var focusStart: Color {
        return Color(hex: "ED8770")
    }
    static var secondaryStart: Color {
        return primaryApp
    }
    static var secondaryEnd: Color {
        return Color(hex: "657DDF")
    }
    static var org: Color {
        return Color(hex: "E1914B")
    }
    static var primaryText: Color {
        return Color.white
    }
    static var primaryText80: Color {
        return Color.white.opacity(0.8)
    }
    static var primaryText60: Color {
        return Color.white.opacity(0.6)
    }
    static var primaryText35: Color {
        return Color.white.opacity(0.35)
    }
    static var primaryText28: Color {
        return Color.white.opacity(0.28)
    }
    static var primaryText10: Color {
        return Color.white.opacity(0.1)
    }
    static var secondaryText: Color {
        return Color(hex: "585A66")
    }
    
    static var primaryG: [Color] {
        return [focusStart, focus]
    }
    static var secondaryG: [Color] {
        return [secondaryStart, secondaryEnd]
    }
    static var bg: Color {
        return Color(hex: "121212")
    }
    
    static var lightBg: Color {
        return Color(hex: "2A2A2A")
    }
    
    static var elementBg: Color {
        return Color(hex: "414141")
    }
    static var darkGray: Color {
        return Color(hex: "383B49")
    }
    static var lightGray: Color {
        return Color(hex: "D0D1D4")
    }
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB(12 -bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit) пере
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double (r) / 255,
            green: Double(g) / 255,
            blue: Double (b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View{
    func cornerRadius(_ radius: CGFloat, corner: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corner: corner))
    }
}

struct RoundedCorner: Shape{
    var radius: CGFloat = .infinity
    var corner: UIRectCorner
    
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}



struct RoundedCorners: Shape {
    var radius: CGFloat = 12
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
