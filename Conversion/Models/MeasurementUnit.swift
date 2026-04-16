import Foundation

enum MeasurementUnit: Hashable, Sendable {
    case length(LengthUnit)
    case mass(MassUnit)
    case temperature(TemperatureUnit)
    case volume(VolumeUnit)
    case speed(SpeedUnit)
    case pressure(PressureUnit)
    case area(AreaUnit)
    case angle(AngleUnit)
    case power(PowerUnit)

    func convertedValue(_ value: Double, to target: MeasurementUnit) -> Double {
        switch (self, target) {
        case let (.length(from), .length(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.mass(from), .mass(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.temperature(from), .temperature(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.volume(from), .volume(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.speed(from), .speed(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.pressure(from), .pressure(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.area(from), .area(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.angle(from), .angle(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.power(from), .power(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        default:
            assertionFailure("Attempted conversion across incompatible dimensions: \(self) -> \(target)")
            return value
        }
    }
}

enum LengthUnit: Hashable, Sendable {
    case millimeters
    case centimeters
    case meters
    case kilometers
    case inches
    case feet
    case miles
    case yards

    var foundationUnit: UnitLength {
        switch self {
        case .millimeters: .millimeters
        case .centimeters: .centimeters
        case .meters: .meters
        case .kilometers: .kilometers
        case .inches: .inches
        case .feet: .feet
        case .miles: .miles
        case .yards: .yards
        }
    }
}

enum MassUnit: Hashable, Sendable {
    case grams
    case kilograms
    case ounces
    case pounds

    var foundationUnit: UnitMass {
        switch self {
        case .grams: .grams
        case .kilograms: .kilograms
        case .ounces: .ounces
        case .pounds: .pounds
        }
    }
}

enum TemperatureUnit: Hashable, Sendable {
    case celsius
    case fahrenheit
    case kelvin

    var foundationUnit: UnitTemperature {
        switch self {
        case .celsius: .celsius
        case .fahrenheit: .fahrenheit
        case .kelvin: .kelvin
        }
    }
}

enum VolumeUnit: Hashable, Sendable {
    case teaspoons
    case tablespoons
    case milliliters
    case liters
    case pints
    case quarts
    case gallons
    case cups
    case fluidOunces

    var foundationUnit: UnitVolume {
        switch self {
        case .teaspoons: .teaspoons
        case .tablespoons: .tablespoons
        case .milliliters: .milliliters
        case .liters: .liters
        case .pints: .pints
        case .quarts: .quarts
        case .gallons: .gallons
        case .cups: .cups
        case .fluidOunces: .fluidOunces
        }
    }
}

enum SpeedUnit: Hashable, Sendable {
    case milesPerHour
    case kilometersPerHour
    case metersPerSecond

    var foundationUnit: UnitSpeed {
        switch self {
        case .milesPerHour: .milesPerHour
        case .kilometersPerHour: .kilometersPerHour
        case .metersPerSecond: .metersPerSecond
        }
    }
}

enum AreaUnit: Hashable, Sendable {
    case acres
    case hectares
    case squareFeet
    case squareMeters

    var foundationUnit: UnitArea {
        switch self {
        case .acres: .acres
        case .hectares: .hectares
        case .squareFeet: .squareFeet
        case .squareMeters: .squareMeters
        }
    }
}

enum PressureUnit: Hashable, Sendable {
    case poundsPerSquareInch
    case bars
    case kilopascals

    var foundationUnit: UnitPressure {
        switch self {
        case .poundsPerSquareInch: .poundsForcePerSquareInch
        case .bars: .bars
        case .kilopascals: .kilopascals
        }
    }
}

enum AngleUnit: Hashable, Sendable {
    case radians
    case degrees

    var foundationUnit: UnitAngle {
        switch self {
        case .radians: .radians
        case .degrees: .degrees
        }
    }
}

enum PowerUnit: Hashable, Sendable {
    case horsepower
    case kilowatts

    var foundationUnit: UnitPower {
        switch self {
        case .horsepower: .horsepower
        case .kilowatts: .kilowatts
        }
    }
}
