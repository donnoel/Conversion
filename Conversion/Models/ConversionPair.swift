import Foundation

struct ConversionPair: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let category: ConversionCategory
    let unitA: String
    let unitB: String
    let rule: ConversionRule

    func convert(_ value: Double, isReversed: Bool) -> Double {
        let direction: ConversionDirection = isReversed ? .unitBToUnitA : .unitAToUnitB
        return rule.convert(value, direction: direction)
    }
}
