import Foundation

enum ConversionCatalog {
    static let allPairs: [ConversionPair] = [
        ConversionPair(id: "length.cm-in", title: "cm <-> inches", category: .length, unitA: "cm", unitB: "in", rule: .linear(multiplier: 0.3937007874)),
        ConversionPair(id: "weight.kg-lb", title: "kg <-> lbs", category: .weightMass, unitA: "kg", unitB: "lb", rule: .linear(multiplier: 2.2046226218)),
        ConversionPair(id: "temp.c-f", title: "Celsius <-> Fahrenheit", category: .temperature, unitA: "C", unitB: "F", rule: .affine(scale: 9.0 / 5.0, offset: 32.0)),
        ConversionPair(id: "length.mm-in", title: "mm <-> inches", category: .length, unitA: "mm", unitB: "in", rule: .linear(multiplier: 0.03937007874)),
        ConversionPair(id: "length.m-ft", title: "meters <-> feet", category: .length, unitA: "m", unitB: "ft", rule: .linear(multiplier: 3.280839895)),
        ConversionPair(id: "length.km-mi", title: "km <-> miles", category: .length, unitA: "km", unitB: "mi", rule: .linear(multiplier: 0.6213711922)),
        ConversionPair(id: "length.cm-ft", title: "cm <-> feet", category: .length, unitA: "cm", unitB: "ft", rule: .linear(multiplier: 0.03280839895)),
        ConversionPair(id: "weight.g-oz", title: "grams <-> ounces", category: .weightMass, unitA: "g", unitB: "oz", rule: .linear(multiplier: 0.03527396195)),
        ConversionPair(id: "length.in-ft", title: "inches <-> feet", category: .length, unitA: "in", unitB: "ft", rule: .linear(multiplier: 1.0 / 12.0)),
        ConversionPair(id: "volume.l-gal", title: "liters <-> gallons", category: .volume, unitA: "L", unitB: "gal", rule: .linear(multiplier: 0.2641720524)),
        ConversionPair(id: "weight.lb-oz", title: "pounds <-> ounces", category: .weightMass, unitA: "lb", unitB: "oz", rule: .linear(multiplier: 16.0)),
        ConversionPair(id: "speed.mph-kph", title: "mph <-> kph", category: .speed, unitA: "mph", unitB: "kph", rule: .linear(multiplier: 1.609344)),
        ConversionPair(id: "area.acre-sqft", title: "acres <-> square feet", category: .area, unitA: "ac", unitB: "sq ft", rule: .linear(multiplier: 43_560.0)),
        ConversionPair(id: "angle.rad-deg", title: "radians <-> degrees", category: .angle, unitA: "rad", unitB: "deg", rule: .linear(multiplier: 180.0 / .pi)),
        ConversionPair(id: "power.hp-kw", title: "hp <-> kw", category: .power, unitA: "hp", unitB: "kw", rule: .linear(multiplier: 0.745699872)),
        ConversionPair(id: "length.m-yd", title: "meters <-> yards", category: .length, unitA: "m", unitB: "yd", rule: .linear(multiplier: 1.093613298)),
        ConversionPair(id: "volume.ml-cup", title: "mL <-> cups", category: .volume, unitA: "mL", unitB: "cup", rule: .linear(multiplier: 0.0042267528377))
    ]

    static func pairs(for category: ConversionCategory) -> [ConversionPair] {
        allPairs.filter { $0.category == category }
    }

    static func pair(withID id: String) -> ConversionPair? {
        allPairs.first(where: { $0.id == id })
    }
}
