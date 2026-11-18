import Combine
import Foundation

struct ToolkitConversionResult: Identifiable, Equatable {
    let unitSymbol: String
    let unitName: String
    let outputValue: Double?

    var id: String {
        unitSymbol
    }

    var outputText: String {
        guard let outputValue else {
            return "--"
        }
        return outputValue.isFinite ? NumberFormatting.display(outputValue) : "Out of range"
    }

    var copyText: String? {
        guard outputValue?.isFinite == true else { return nil }
        return "\(outputText) \(unitSymbol)"
    }
}

@MainActor
final class ToolkitViewModel: ObservableObject {
    @Published var selectedCategory: ConversionCategory {
        didSet {
            guard oldValue != selectedCategory else { return }
            guard availableUnitSymbols.contains(sourceUnitSymbol) else {
                sourceUnitSymbol = defaultSourceUnitSymbol(for: selectedCategory) ?? ""
                return
            }
        }
    }

    @Published var sourceUnitSymbol: String
    @Published var inputText: String = ""

    private let unitsByCategory: [ConversionCategory: [String: MeasurementUnit]]

    private static let preferredUnitOrder: [ConversionCategory: [String]] = [
        .length: ["km", "mi", "m", "ft", "yd", "cm", "mm", "in"],
        .weightMass: ["kg", "lb", "g", "oz"],
        .temperature: ["c", "f", "K"],
        .volume: ["L", "qt", "pt", "gal", "cup", "fl oz", "tbsp", "tsp", "mL"],
        .speed: ["kph", "mph", "m/s"],
        .pressure: ["psi", "bar", "kPa"],
        .area: ["ha", "ac", "sq m", "sq ft"],
        .angle: ["deg", "rad"],
        .power: ["kw", "hp"],
        .time: ["day", "hr", "min", "sec"],
        .data: ["TB", "GB", "MB", "KB"],
        .fuelEconomy: ["mpg", "L/100km", "km/L"],
        .energy: ["kWh", "Wh", "kcal", "cal", "J"],
        .torque: ["Nm", "lb-ft", "in-lb"]
    ]

    var categories: [ConversionCategory] {
        ConversionCategory.allCases.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    var availableUnitSymbols: [String] {
        orderedUnitSymbols(for: selectedCategory)
    }

    var conversionResults: [ToolkitConversionResult] {
        let parsedInput = NumericInputParser.parse(inputText)

        return availableUnitSymbols
            .filter { $0 != sourceUnitSymbol }
            .map { targetSymbol in
                let outputValue = parsedInput.flatMap { value in
                    convert(value: value, from: sourceUnitSymbol, to: targetSymbol)
                }

                return ToolkitConversionResult(
                    unitSymbol: targetSymbol,
                    unitName: unitDisplayName(for: targetSymbol),
                    outputValue: outputValue
                )
            }
    }

    init(defaultCategory: ConversionCategory = .length) {
        unitsByCategory = Self.makeUnitsByCategory(from: ConversionCatalog.allPairs)

        if ConversionCategory.allCases.contains(defaultCategory) {
            selectedCategory = defaultCategory
        } else {
            selectedCategory = .length
        }

        sourceUnitSymbol = ""
        sourceUnitSymbol = defaultSourceUnitSymbol(for: selectedCategory) ?? ""
    }

    func unitDisplayName(for symbol: String) -> String {
        ConversionCatalog.unitName(for: symbol)
    }

    func useConverter(pair: ConversionPair, inputText: String, isReversed: Bool) {
        selectedCategory = pair.category
        let sourceSymbol = isReversed ? pair.unitB : pair.unitA

        if availableUnitSymbols.contains(sourceSymbol) {
            sourceUnitSymbol = sourceSymbol
        }

        self.inputText = inputText
    }

    private func convert(value: Double, from sourceSymbol: String, to targetSymbol: String) -> Double? {
        guard
            let units = unitsByCategory[selectedCategory],
            let sourceUnit = units[sourceSymbol],
            let targetUnit = units[targetSymbol]
        else {
            return nil
        }

        return sourceUnit.convertedValue(value, to: targetUnit)
    }

    private func defaultSourceUnitSymbol(for category: ConversionCategory) -> String? {
        orderedUnitSymbols(for: category).first
    }

    private func orderedUnitSymbols(for category: ConversionCategory) -> [String] {
        let symbols = Array((unitsByCategory[category] ?? [:]).keys)
        let preferredOrder = Self.preferredUnitOrder[category] ?? []

        return symbols.sorted { lhs, rhs in
            let leftRank = preferredOrder.firstIndex(of: lhs) ?? .max
            let rightRank = preferredOrder.firstIndex(of: rhs) ?? .max

            if leftRank != rightRank {
                return leftRank < rightRank
            }

            let leftName = unitDisplayName(for: lhs)
            let rightName = unitDisplayName(for: rhs)
            return leftName.localizedCaseInsensitiveCompare(rightName) == .orderedAscending
        }
    }

    private static func makeUnitsByCategory(from pairs: [ConversionPair]) -> [ConversionCategory: [String: MeasurementUnit]] {
        var result: [ConversionCategory: [String: MeasurementUnit]] = [:]

        for pair in pairs {
            let units: (MeasurementUnit, MeasurementUnit)
            switch pair.rule {
            case let .measurement(unitA, unitB):
                units = (unitA, unitB)
            }

            var categoryUnits = result[pair.category] ?? [:]
            categoryUnits[pair.unitA] = units.0
            categoryUnits[pair.unitB] = units.1
            result[pair.category] = categoryUnits
        }

        return result
    }
}
