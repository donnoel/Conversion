import Foundation

struct ConversionPair: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let category: ConversionCategory
    let unitA: String
    let unitB: String
    let rule: ConversionRule

    var displayTitle: String {
        "\(ConversionCatalog.unitName(for: unitA)) ↔ \(ConversionCatalog.unitName(for: unitB))"
    }

    var spokenTitle: String {
        "\(ConversionCatalog.unitName(for: unitA)) and \(ConversionCatalog.unitName(for: unitB))"
    }

    func matchesSearch(_ query: String) -> Bool {
        let terms = [title, unitA, unitB, displayTitle, category.title]
        return query.isEmpty || terms.contains { $0.localizedStandardContains(query) }
    }

    func convert(_ value: Double, isReversed: Bool) -> Double {
        let direction: ConversionDirection = isReversed ? .unitBToUnitA : .unitAToUnitB
        return rule.convert(value, direction: direction)
    }
}
