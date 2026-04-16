import Foundation

enum ConversionCatalog {
    static let allPairs: [ConversionPair] = [
        ConversionPair(id: "length.cm-in", title: "cm <-> inches", category: .length, unitA: "cm", unitB: "in", rule: .measurement(unitA: .length(.centimeters), unitB: .length(.inches))),
        ConversionPair(id: "length.m-cm", title: "meters <-> centimeters", category: .length, unitA: "m", unitB: "cm", rule: .measurement(unitA: .length(.meters), unitB: .length(.centimeters))),
        ConversionPair(id: "weight.kg-lb", title: "kg <-> lbs", category: .weightMass, unitA: "kg", unitB: "lb", rule: .measurement(unitA: .mass(.kilograms), unitB: .mass(.pounds))),
        ConversionPair(id: "weight.kg-g", title: "kg <-> grams", category: .weightMass, unitA: "kg", unitB: "g", rule: .measurement(unitA: .mass(.kilograms), unitB: .mass(.grams))),
        ConversionPair(id: "temp.c-f", title: "celsius <-> fahrenheit", category: .temperature, unitA: "c", unitB: "f", rule: .measurement(unitA: .temperature(.celsius), unitB: .temperature(.fahrenheit))),
        ConversionPair(id: "temp.c-k", title: "celsius <-> kelvin", category: .temperature, unitA: "c", unitB: "K", rule: .measurement(unitA: .temperature(.celsius), unitB: .temperature(.kelvin))),
        ConversionPair(id: "length.mm-in", title: "mm <-> inches", category: .length, unitA: "mm", unitB: "in", rule: .measurement(unitA: .length(.millimeters), unitB: .length(.inches))),
        ConversionPair(id: "length.m-ft", title: "meters <-> feet", category: .length, unitA: "m", unitB: "ft", rule: .measurement(unitA: .length(.meters), unitB: .length(.feet))),
        ConversionPair(id: "length.km-mi", title: "km <-> miles", category: .length, unitA: "km", unitB: "mi", rule: .measurement(unitA: .length(.kilometers), unitB: .length(.miles))),
        ConversionPair(id: "length.mi-ft", title: "miles <-> feet", category: .length, unitA: "mi", unitB: "ft", rule: .measurement(unitA: .length(.miles), unitB: .length(.feet))),
        ConversionPair(id: "length.cm-ft", title: "cm <-> feet", category: .length, unitA: "cm", unitB: "ft", rule: .measurement(unitA: .length(.centimeters), unitB: .length(.feet))),
        ConversionPair(id: "weight.lb-g", title: "lb <-> grams", category: .weightMass, unitA: "lb", unitB: "g", rule: .measurement(unitA: .mass(.pounds), unitB: .mass(.grams))),
        ConversionPair(id: "weight.g-oz", title: "grams <-> ounces", category: .weightMass, unitA: "g", unitB: "oz", rule: .measurement(unitA: .mass(.grams), unitB: .mass(.ounces))),
        ConversionPair(id: "length.in-ft", title: "inches <-> feet", category: .length, unitA: "in", unitB: "ft", rule: .measurement(unitA: .length(.inches), unitB: .length(.feet))),
        ConversionPair(id: "volume.tsp-ml", title: "tsp <-> mL", category: .volume, unitA: "tsp", unitB: "mL", rule: .measurement(unitA: .volume(.teaspoons), unitB: .volume(.milliliters))),
        ConversionPair(id: "volume.tbsp-ml", title: "tbsp <-> mL", category: .volume, unitA: "tbsp", unitB: "mL", rule: .measurement(unitA: .volume(.tablespoons), unitB: .volume(.milliliters))),
        ConversionPair(id: "volume.l-gal", title: "liters <-> gallons", category: .volume, unitA: "L", unitB: "gal", rule: .measurement(unitA: .volume(.liters), unitB: .volume(.gallons))),
        ConversionPair(id: "volume.pt-l", title: "pt <-> L", category: .volume, unitA: "pt", unitB: "L", rule: .measurement(unitA: .volume(.pints), unitB: .volume(.liters))),
        ConversionPair(id: "volume.qt-l", title: "qt <-> L", category: .volume, unitA: "qt", unitB: "L", rule: .measurement(unitA: .volume(.quarts), unitB: .volume(.liters))),
        ConversionPair(id: "weight.lb-oz", title: "pounds <-> ounces", category: .weightMass, unitA: "lb", unitB: "oz", rule: .measurement(unitA: .mass(.pounds), unitB: .mass(.ounces))),
        ConversionPair(id: "speed.mph-kph", title: "kph <-> mph", category: .speed, unitA: "kph", unitB: "mph", rule: .measurement(unitA: .speed(.kilometersPerHour), unitB: .speed(.milesPerHour))),
        ConversionPair(id: "speed.kph-ms", title: "kph <-> m/s", category: .speed, unitA: "kph", unitB: "m/s", rule: .measurement(unitA: .speed(.kilometersPerHour), unitB: .speed(.metersPerSecond))),
        ConversionPair(id: "speed.mph-ms", title: "mph <-> m/s", category: .speed, unitA: "mph", unitB: "m/s", rule: .measurement(unitA: .speed(.milesPerHour), unitB: .speed(.metersPerSecond))),
        ConversionPair(id: "pressure.psi-bar", title: "psi <-> bar", category: .pressure, unitA: "psi", unitB: "bar", rule: .measurement(unitA: .pressure(.poundsPerSquareInch), unitB: .pressure(.bars))),
        ConversionPair(id: "pressure.psi-kpa", title: "psi <-> kPa", category: .pressure, unitA: "psi", unitB: "kPa", rule: .measurement(unitA: .pressure(.poundsPerSquareInch), unitB: .pressure(.kilopascals))),
        ConversionPair(id: "pressure.bar-kpa", title: "bar <-> kPa", category: .pressure, unitA: "bar", unitB: "kPa", rule: .measurement(unitA: .pressure(.bars), unitB: .pressure(.kilopascals))),
        ConversionPair(id: "area.ac-ha", title: "acres <-> hectares", category: .area, unitA: "ac", unitB: "ha", rule: .measurement(unitA: .area(.acres), unitB: .area(.hectares))),
        ConversionPair(id: "area.acre-sqft", title: "acres <-> square feet", category: .area, unitA: "ac", unitB: "sq ft", rule: .measurement(unitA: .area(.acres), unitB: .area(.squareFeet))),
        ConversionPair(id: "area.sqft-sqm", title: "square feet <-> square meters", category: .area, unitA: "sq ft", unitB: "sq m", rule: .measurement(unitA: .area(.squareFeet), unitB: .area(.squareMeters))),
        ConversionPair(id: "angle.rad-deg", title: "radians <-> degrees", category: .angle, unitA: "rad", unitB: "deg", rule: .measurement(unitA: .angle(.radians), unitB: .angle(.degrees))),
        ConversionPair(id: "power.hp-kw", title: "hp <-> kw", category: .power, unitA: "hp", unitB: "kw", rule: .measurement(unitA: .power(.horsepower), unitB: .power(.kilowatts))),
        ConversionPair(id: "length.m-yd", title: "meters <-> yards", category: .length, unitA: "m", unitB: "yd", rule: .measurement(unitA: .length(.meters), unitB: .length(.yards))),
        ConversionPair(id: "volume.ml-cup", title: "mL <-> cups", category: .volume, unitA: "mL", unitB: "cup", rule: .measurement(unitA: .volume(.milliliters), unitB: .volume(.cups))),
        ConversionPair(id: "volume.floz-ml", title: "fl oz <-> mL", category: .volume, unitA: "fl oz", unitB: "mL", rule: .measurement(unitA: .volume(.fluidOunces), unitB: .volume(.milliliters)))
    ]

    static func pairs(for category: ConversionCategory) -> [ConversionPair] {
        allPairs.filter { $0.category == category }
    }

    static func pair(withID id: String) -> ConversionPair? {
        allPairs.first(where: { $0.id == id })
    }
}
