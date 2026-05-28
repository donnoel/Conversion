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
    case time(TimeUnit)
    case data(DataUnit)
    case fuelEconomy(FuelEconomyUnit)
    case energy(EnergyUnit)
    case torque(TorqueUnit)

    func convertedValue(_ value: Double, to target: MeasurementUnit) -> Double {
        switch (self, target) {
        case let (.length(from), .length(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.mass(from), .mass(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.temperature(from), .temperature(to)):
            return Measurement(value: value, unit: from.foundationUnit).converted(to: to.foundationUnit).value
        case let (.volume(from), .volume(to)):
            return from.convert(value, to: to)
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
        case let (.time(from), .time(to)):
            return from.convert(value, to: to)
        case let (.data(from), .data(to)):
            return from.convert(value, to: to)
        case let (.fuelEconomy(from), .fuelEconomy(to)):
            return from.convert(value, to: to)
        case let (.energy(from), .energy(to)):
            return from.convert(value, to: to)
        case let (.torque(from), .torque(to)):
            return from.convert(value, to: to)
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

    private var litersFactor: Double {
        switch self {
        case .teaspoons: 0.004_928_921_593_75
        case .tablespoons: 0.014_786_764_781_25
        case .milliliters: 0.001
        case .liters: 1
        case .pints: 0.473_176_473
        case .quarts: 0.946_352_946
        case .gallons: 3.785_411_784
        case .cups: 0.236_588_236_5
        case .fluidOunces: 0.029_573_529_562_5
        }
    }

    func convert(_ value: Double, to target: VolumeUnit) -> Double {
        value * litersFactor / target.litersFactor
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

enum TimeUnit: Hashable, Sendable {
    case seconds
    case minutes
    case hours
    case days

    private var secondsFactor: Double {
        switch self {
        case .seconds: 1
        case .minutes: 60
        case .hours: 3_600
        case .days: 86_400
        }
    }

    func convert(_ value: Double, to target: TimeUnit) -> Double {
        value * secondsFactor / target.secondsFactor
    }
}

enum DataUnit: Hashable, Sendable {
    case kilobytes
    case megabytes
    case gigabytes
    case terabytes

    private var bytesFactor: Double {
        switch self {
        case .kilobytes: 1_000
        case .megabytes: 1_000_000
        case .gigabytes: 1_000_000_000
        case .terabytes: 1_000_000_000_000
        }
    }

    func convert(_ value: Double, to target: DataUnit) -> Double {
        value * bytesFactor / target.bytesFactor
    }
}

enum FuelEconomyUnit: Hashable, Sendable {
    case milesPerGallon
    case litersPer100Kilometers
    case kilometersPerLiter

    func convert(_ value: Double, to target: FuelEconomyUnit) -> Double {
        let kilometersPerLiter = toKilometersPerLiter(value)
        return target.fromKilometersPerLiter(kilometersPerLiter)
    }

    private func toKilometersPerLiter(_ value: Double) -> Double {
        switch self {
        case .milesPerGallon:
            value * 1.609_344 / 3.785_411_784
        case .litersPer100Kilometers:
            100 / value
        case .kilometersPerLiter:
            value
        }
    }

    private func fromKilometersPerLiter(_ value: Double) -> Double {
        switch self {
        case .milesPerGallon:
            value * 3.785_411_784 / 1.609_344
        case .litersPer100Kilometers:
            100 / value
        case .kilometersPerLiter:
            value
        }
    }
}

enum EnergyUnit: Hashable, Sendable {
    case joules
    case calories
    case kilocalories
    case wattHours
    case kilowattHours

    private var joulesFactor: Double {
        switch self {
        case .joules: 1
        case .calories: 4.184
        case .kilocalories: 4_184
        case .wattHours: 3_600
        case .kilowattHours: 3_600_000
        }
    }

    func convert(_ value: Double, to target: EnergyUnit) -> Double {
        value * joulesFactor / target.joulesFactor
    }
}

enum TorqueUnit: Hashable, Sendable {
    case newtonMeters
    case poundFeet
    case poundInches

    private var newtonMeterFactor: Double {
        switch self {
        case .newtonMeters: 1
        case .poundFeet: 1.355_817_948_331_400_4
        case .poundInches: 0.112_984_829_027_616_7
        }
    }

    func convert(_ value: Double, to target: TorqueUnit) -> Double {
        value * newtonMeterFactor / target.newtonMeterFactor
    }
}
