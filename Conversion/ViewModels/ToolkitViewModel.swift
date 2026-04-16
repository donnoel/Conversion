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
        return NumberFormatting.display(outputValue)
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
        .power: ["kw", "hp"]
    ]

    private static let unitDisplayNames: [String: String] = [
        "cm": "centimeters",
        "in": "inches",
        "kg": "kilograms",
        "lb": "pounds",
        "c": "celsius",
        "f": "fahrenheit",
        "K": "kelvin",
        "mm": "millimeters",
        "m": "meters",
        "ft": "feet",
        "km": "kilometers",
        "mi": "miles",
        "g": "grams",
        "oz": "ounces",
        "L": "liters",
        "pt": "pints",
        "qt": "quarts",
        "gal": "gallons",
        "tsp": "teaspoons",
        "tbsp": "tablespoons",
        "mph": "miles per hour",
        "kph": "kilometers per hour",
        "m/s": "meters per second",
        "psi": "pounds per square inch",
        "bar": "bar",
        "kPa": "kilopascals",
        "ac": "acres",
        "ha": "hectares",
        "sq ft": "square feet",
        "sq m": "square meters",
        "rad": "radians",
        "deg": "degrees",
        "hp": "horsepower",
        "kw": "kilowatts",
        "yd": "yards",
        "mL": "milliliters",
        "fl oz": "fluid ounces",
        "cup": "cups"
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
        Self.unitDisplayNames[symbol] ?? symbol
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
