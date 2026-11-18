import Foundation

enum NumberFormatting {
    static func display(_ value: Double, locale: Locale = .autoupdatingCurrent) -> String {
        format(value, fractionDigits: 3, roundingThreshold: 0.000_5, locale: locale)
    }

    static func precise(_ value: Double, locale: Locale = .autoupdatingCurrent) -> String {
        format(value, fractionDigits: 8, roundingThreshold: 0.000_000_005, locale: locale)
    }

    private static func format(
        _ value: Double,
        fractionDigits: Int,
        roundingThreshold: Double,
        locale: Locale
    ) -> String {
        let magnitude = abs(value)
        let style = FloatingPointFormatStyle<Double>(locale: locale)
        if magnitude > 0 && magnitude <= roundingThreshold {
            let significant = style.precision(.significantDigits(1 ... 3))
            return value.formatted(magnitude < 0.000_000_01 ? significant.notation(.scientific) : significant)
        }

        let normalized = value == 0 ? 0.0 : value
        return normalized.formatted(
            style.grouping(.automatic).precision(.fractionLength(0 ... fractionDigits))
        )
    }
}

enum NumericInputParser {
    static func parse(_ text: String) -> Double? {
        guard let value = Double(normalizedInput(text)), value.isFinite else { return nil }
        return value
    }

    static func isIncomplete(_ text: String) -> Bool {
        ["", "+", "-", ".", "+.", "-."].contains(normalizedInput(text))
    }

    private static func normalizedInput(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".")
    }
}
