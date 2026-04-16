import Foundation

enum NumberFormatting {
    static func display(_ value: Double, locale: Locale = .autoupdatingCurrent) -> String {
        let normalized = abs(value) < 0.000_000_000_1 ? 0.0 : value
        return normalized.formatted(
            .number
                .grouping(.automatic)
                .precision(.fractionLength(0 ... 3))
                .locale(locale)
        )
    }
}

enum NumericInputParser {
    static func parse(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        guard normalized != "-", normalized != ".", normalized != "-." else {
            return nil
        }

        return Double(normalized)
    }
}
