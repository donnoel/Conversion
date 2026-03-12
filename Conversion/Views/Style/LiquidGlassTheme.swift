import SwiftUI

enum LiquidGlassTheme {
    static let tint = Color(red: 0.16, green: 0.46, blue: 0.84)
    static let softTint = Color(red: 0.72, green: 0.84, blue: 0.96)
    static let surfaceStroke = Color.white.opacity(0.20)
    static let cardCornerRadius: CGFloat = 24
    static let controlCornerRadius: CGFloat = 16
    static let chipCornerRadius: CGFloat = 14
    static let cardPadding: CGFloat = 16
    static let contentWidth: CGFloat = 980
    static let sectionSpacing: CGFloat = 16

    static func canvasGradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.08, blue: 0.14),
                    Color(red: 0.07, green: 0.13, blue: 0.20),
                    Color(red: 0.09, green: 0.18, blue: 0.26)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        return LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.97, blue: 1.0),
                Color(red: 0.90, green: 0.94, blue: 0.99),
                Color(red: 0.87, green: 0.92, blue: 0.98)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func screenGlow(for colorScheme: ColorScheme) -> some ShapeStyle {
        if colorScheme == .dark {
            return RadialGradient(
                colors: [
                    tint.opacity(0.35),
                    .clear
                ],
                center: .topLeading,
                startRadius: 20,
                endRadius: 680
            )
        }

        return RadialGradient(
            colors: [
                softTint.opacity(0.55),
                .clear
            ],
            center: .topLeading,
            startRadius: 20,
            endRadius: 700
        )
    }

    static func heroBackground(for colorScheme: ColorScheme) -> some ShapeStyle {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [
                    Color.white.opacity(0.14),
                    Color.white.opacity(0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        return LinearGradient(
            colors: [
                Color.white.opacity(0.86),
                Color.white.opacity(0.58)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func cardStroke(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white.opacity(0.17) : Color.white.opacity(0.38)
    }

    static func chipFill(isSelected: Bool, colorScheme: ColorScheme) -> Color {
        guard isSelected else {
            return colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.46)
        }
        return tint.opacity(colorScheme == .dark ? 0.28 : 0.18)
    }

    static func chipStroke(isSelected: Bool, colorScheme: ColorScheme) -> Color {
        guard isSelected else {
            return colorScheme == .dark ? Color.white.opacity(0.10) : Color.white.opacity(0.45)
        }
        return tint.opacity(colorScheme == .dark ? 0.52 : 0.44)
    }
}

struct LiquidGlassCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                .thinMaterial,
                in: RoundedRectangle(cornerRadius: LiquidGlassTheme.cardCornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: LiquidGlassTheme.cardCornerRadius, style: .continuous)
                    .strokeBorder(LiquidGlassTheme.cardStroke(for: colorScheme), lineWidth: 0.7)
            )
            .shadow(
                color: .black.opacity(colorScheme == .dark ? 0.22 : 0.08),
                radius: colorScheme == .dark ? 16 : 10,
                x: 0,
                y: colorScheme == .dark ? 8 : 5
            )
    }
}

struct LiquidGlassSurfaceModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(LiquidGlassTheme.surfaceStroke, lineWidth: 0.7)
            )
    }
}

extension View {
    func liquidGlassCardStyle() -> some View {
        modifier(LiquidGlassCardModifier())
    }

    func liquidGlassSurfaceStyle(cornerRadius: CGFloat = LiquidGlassTheme.controlCornerRadius) -> some View {
        modifier(LiquidGlassSurfaceModifier(cornerRadius: cornerRadius))
    }
}
