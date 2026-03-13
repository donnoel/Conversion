import Foundation

enum ConversionCatalog {
    static let allPairs: [ConversionPair] = [
        ConversionPair(id: "length.cm-in", title: "cm <-> inches", category: .length, unitA: "cm", unitB: "in", rule: .measurement(unitA: .length(.centimeters), unitB: .length(.inches))),
        ConversionPair(id: "weight.kg-lb", title: "kg <-> lbs", category: .weightMass, unitA: "kg", unitB: "lb", rule: .measurement(unitA: .mass(.kilograms), unitB: .mass(.pounds))),
        ConversionPair(id: "temp.c-f", title: "Celsius <-> Fahrenheit", category: .temperature, unitA: "C", unitB: "F", rule: .measurement(unitA: .temperature(.celsius), unitB: .temperature(.fahrenheit))),
        ConversionPair(id: "length.mm-in", title: "mm <-> inches", category: .length, unitA: "mm", unitB: "in", rule: .measurement(unitA: .length(.millimeters), unitB: .length(.inches))),
        ConversionPair(id: "length.m-ft", title: "meters <-> feet", category: .length, unitA: "m", unitB: "ft", rule: .measurement(unitA: .length(.meters), unitB: .length(.feet))),
        ConversionPair(id: "length.km-mi", title: "km <-> miles", category: .length, unitA: "km", unitB: "mi", rule: .measurement(unitA: .length(.kilometers), unitB: .length(.miles))),
        ConversionPair(id: "length.cm-ft", title: "cm <-> feet", category: .length, unitA: "cm", unitB: "ft", rule: .measurement(unitA: .length(.centimeters), unitB: .length(.feet))),
        ConversionPair(id: "weight.g-oz", title: "grams <-> ounces", category: .weightMass, unitA: "g", unitB: "oz", rule: .measurement(unitA: .mass(.grams), unitB: .mass(.ounces))),
        ConversionPair(id: "length.in-ft", title: "inches <-> feet", category: .length, unitA: "in", unitB: "ft", rule: .measurement(unitA: .length(.inches), unitB: .length(.feet))),
        ConversionPair(id: "volume.l-gal", title: "liters <-> gallons", category: .volume, unitA: "L", unitB: "gal", rule: .measurement(unitA: .volume(.liters), unitB: .volume(.gallons))),
        ConversionPair(id: "weight.lb-oz", title: "pounds <-> ounces", category: .weightMass, unitA: "lb", unitB: "oz", rule: .measurement(unitA: .mass(.pounds), unitB: .mass(.ounces))),
        ConversionPair(id: "speed.mph-kph", title: "kph <-> mph", category: .speed, unitA: "kph", unitB: "mph", rule: .measurement(unitA: .speed(.kilometersPerHour), unitB: .speed(.milesPerHour))),
        ConversionPair(id: "area.acre-sqft", title: "acres <-> square feet", category: .area, unitA: "ac", unitB: "sq ft", rule: .measurement(unitA: .area(.acres), unitB: .area(.squareFeet))),
        ConversionPair(id: "angle.rad-deg", title: "radians <-> degrees", category: .angle, unitA: "rad", unitB: "deg", rule: .measurement(unitA: .angle(.radians), unitB: .angle(.degrees))),
        ConversionPair(id: "power.hp-kw", title: "hp <-> kw", category: .power, unitA: "hp", unitB: "kw", rule: .measurement(unitA: .power(.horsepower), unitB: .power(.kilowatts))),
        ConversionPair(id: "length.m-yd", title: "meters <-> yards", category: .length, unitA: "m", unitB: "yd", rule: .measurement(unitA: .length(.meters), unitB: .length(.yards))),
        ConversionPair(id: "volume.ml-cup", title: "mL <-> cups", category: .volume, unitA: "mL", unitB: "cup", rule: .measurement(unitA: .volume(.milliliters), unitB: .volume(.cups)))
    ]

    static func pairs(for category: ConversionCategory) -> [ConversionPair] {
        allPairs.filter { $0.category == category }
    }

    static func pair(withID id: String) -> ConversionPair? {
        allPairs.first(where: { $0.id == id })
    }
}
