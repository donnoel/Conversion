import Foundation

enum ConversionDirection: Sendable {
    case unitAToUnitB
    case unitBToUnitA
}

enum ConversionRule: Hashable, Sendable {
    case linear(multiplier: Double)
    case affine(scale: Double, offset: Double)

    func convert(_ value: Double, direction: ConversionDirection) -> Double {
        switch self {
        case let .linear(multiplier):
            switch direction {
            case .unitAToUnitB:
                value * multiplier
            case .unitBToUnitA:
                value / multiplier
            }

        case let .affine(scale, offset):
            switch direction {
            case .unitAToUnitB:
                (value * scale) + offset
            case .unitBToUnitA:
                (value - offset) / scale
            }
        }
    }
}
