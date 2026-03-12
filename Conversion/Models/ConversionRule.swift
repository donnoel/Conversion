import Foundation

enum ConversionDirection: Sendable {
    case unitAToUnitB
    case unitBToUnitA
}

enum ConversionRule: Hashable, Sendable {
    case measurement(unitA: MeasurementUnit, unitB: MeasurementUnit)

    func convert(_ value: Double, direction: ConversionDirection) -> Double {
        switch self {
        case let .measurement(unitA, unitB):
            switch direction {
            case .unitAToUnitB:
                unitA.convertedValue(value, to: unitB)
            case .unitBToUnitA:
                unitB.convertedValue(value, to: unitA)
            }
        }
    }
}
