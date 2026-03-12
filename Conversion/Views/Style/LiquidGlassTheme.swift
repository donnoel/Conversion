import SwiftUI

enum LiquidGlassTheme {
    static let tint = Color(red: 0.30, green: 0.56, blue: 0.83)
    static let surfaceStroke = Color.white.opacity(0.20)

    static func canvasGradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.20, blue: 0.31),
                    Color(red: 0.14, green: 0.24, blue: 0.35),
                    Color(red: 0.16, green: 0.30, blue: 0.42)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        return LinearGradient(
            colors: [
                Color(red: 0.92, green: 0.96, blue: 0.99),
                Color(red: 0.86, green: 0.92, blue: 0.98),
                Color(red: 0.82, green: 0.89, blue: 0.97)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static let cardHighlight = LinearGradient(
        colors: [
            Color.white.opacity(0.24),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct LiquidGlassCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 22, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(LiquidGlassTheme.cardHighlight, lineWidth: 1)
            )
            .shadow(
                color: .black.opacity(colorScheme == .dark ? 0.22 : 0.10),
                radius: 12,
                x: 0,
                y: 8
            )
    }
}

struct LiquidGlassSurfaceModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                .thinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(LiquidGlassTheme.surfaceStroke, lineWidth: 1)
            )
            .shadow(
                color: .black.opacity(colorScheme == .dark ? 0.18 : 0.07),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

extension View {
    func liquidGlassCardStyle() -> some View {
        modifier(LiquidGlassCardModifier())
    }

    func liquidGlassSurfaceStyle(cornerRadius: CGFloat = 14) -> some View {
        modifier(LiquidGlassSurfaceModifier(cornerRadius: cornerRadius))
    }
}
