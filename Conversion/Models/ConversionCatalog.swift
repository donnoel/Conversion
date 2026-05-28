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
        ConversionPair(id: "volume.floz-ml", title: "fl oz <-> mL", category: .volume, unitA: "fl oz", unitB: "mL", rule: .measurement(unitA: .volume(.fluidOunces), unitB: .volume(.milliliters))),
        ConversionPair(id: "volume.cup-tbsp", title: "cups <-> tablespoons", category: .volume, unitA: "cup", unitB: "tbsp", rule: .measurement(unitA: .volume(.cups), unitB: .volume(.tablespoons))),
        ConversionPair(id: "volume.cup-tsp", title: "cups <-> teaspoons", category: .volume, unitA: "cup", unitB: "tsp", rule: .measurement(unitA: .volume(.cups), unitB: .volume(.teaspoons))),
        ConversionPair(id: "volume.cup-pt", title: "cups <-> pints", category: .volume, unitA: "cup", unitB: "pt", rule: .measurement(unitA: .volume(.cups), unitB: .volume(.pints))),
        ConversionPair(id: "volume.gal-qt", title: "gallons <-> quarts", category: .volume, unitA: "gal", unitB: "qt", rule: .measurement(unitA: .volume(.gallons), unitB: .volume(.quarts))),
        ConversionPair(id: "time.sec-min", title: "seconds <-> minutes", category: .time, unitA: "sec", unitB: "min", rule: .measurement(unitA: .time(.seconds), unitB: .time(.minutes))),
        ConversionPair(id: "time.min-hr", title: "minutes <-> hours", category: .time, unitA: "min", unitB: "hr", rule: .measurement(unitA: .time(.minutes), unitB: .time(.hours))),
        ConversionPair(id: "time.hr-day", title: "hours <-> days", category: .time, unitA: "hr", unitB: "day", rule: .measurement(unitA: .time(.hours), unitB: .time(.days))),
        ConversionPair(id: "data.kb-mb", title: "KB <-> MB", category: .data, unitA: "KB", unitB: "MB", rule: .measurement(unitA: .data(.kilobytes), unitB: .data(.megabytes))),
        ConversionPair(id: "data.mb-gb", title: "MB <-> GB", category: .data, unitA: "MB", unitB: "GB", rule: .measurement(unitA: .data(.megabytes), unitB: .data(.gigabytes))),
        ConversionPair(id: "data.gb-tb", title: "GB <-> TB", category: .data, unitA: "GB", unitB: "TB", rule: .measurement(unitA: .data(.gigabytes), unitB: .data(.terabytes))),
        ConversionPair(id: "fuel.mpg-l100km", title: "mpg <-> L/100km", category: .fuelEconomy, unitA: "mpg", unitB: "L/100km", rule: .measurement(unitA: .fuelEconomy(.milesPerGallon), unitB: .fuelEconomy(.litersPer100Kilometers))),
        ConversionPair(id: "fuel.mpg-kml", title: "mpg <-> km/L", category: .fuelEconomy, unitA: "mpg", unitB: "km/L", rule: .measurement(unitA: .fuelEconomy(.milesPerGallon), unitB: .fuelEconomy(.kilometersPerLiter))),
        ConversionPair(id: "fuel.l100km-kml", title: "L/100km <-> km/L", category: .fuelEconomy, unitA: "L/100km", unitB: "km/L", rule: .measurement(unitA: .fuelEconomy(.litersPer100Kilometers), unitB: .fuelEconomy(.kilometersPerLiter))),
        ConversionPair(id: "energy.j-cal", title: "joules <-> calories", category: .energy, unitA: "J", unitB: "cal", rule: .measurement(unitA: .energy(.joules), unitB: .energy(.calories))),
        ConversionPair(id: "energy.cal-kcal", title: "calories <-> kilocalories", category: .energy, unitA: "cal", unitB: "kcal", rule: .measurement(unitA: .energy(.calories), unitB: .energy(.kilocalories))),
        ConversionPair(id: "energy.wh-kwh", title: "Wh <-> kWh", category: .energy, unitA: "Wh", unitB: "kWh", rule: .measurement(unitA: .energy(.wattHours), unitB: .energy(.kilowattHours))),
        ConversionPair(id: "energy.kcal-kwh", title: "kilocalories <-> kWh", category: .energy, unitA: "kcal", unitB: "kWh", rule: .measurement(unitA: .energy(.kilocalories), unitB: .energy(.kilowattHours))),
        ConversionPair(id: "torque.nm-lbft", title: "Nm <-> lb-ft", category: .torque, unitA: "Nm", unitB: "lb-ft", rule: .measurement(unitA: .torque(.newtonMeters), unitB: .torque(.poundFeet))),
        ConversionPair(id: "torque.lbft-lbin", title: "lb-ft <-> in-lb", category: .torque, unitA: "lb-ft", unitB: "in-lb", rule: .measurement(unitA: .torque(.poundFeet), unitB: .torque(.poundInches))),
        ConversionPair(id: "torque.nm-lbin", title: "Nm <-> in-lb", category: .torque, unitA: "Nm", unitB: "in-lb", rule: .measurement(unitA: .torque(.newtonMeters), unitB: .torque(.poundInches)))
    ]

    static func pairs(for category: ConversionCategory) -> [ConversionPair] {
        allPairs.filter { $0.category == category }
    }

    static func pair(withID id: String) -> ConversionPair? {
        allPairs.first(where: { $0.id == id })
    }
}
