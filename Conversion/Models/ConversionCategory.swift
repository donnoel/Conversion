import Foundation

enum ConversionCategory: String, CaseIterable, Identifiable, Sendable {
    case length
    case weightMass
    case temperature
    case volume
    case speed
    case area
    case angle
    case power

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .length:
            "Length"
        case .weightMass:
            "Weight / Mass"
        case .temperature:
            "Temperature"
        case .volume:
            "Volume"
        case .speed:
            "Speed"
        case .area:
            "Area"
        case .angle:
            "Angle"
        case .power:
            "Power"
        }
    }
}
