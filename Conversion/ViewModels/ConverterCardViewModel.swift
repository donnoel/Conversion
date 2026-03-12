import Combine
import Foundation

@MainActor
final class ConverterCardViewModel: ObservableObject {
    let pair: ConversionPair

    @Published var inputText: String = ""
    @Published private(set) var isReversed: Bool = false

    init(pair: ConversionPair) {
        self.pair = pair
    }

    var inputUnit: String {
        isReversed ? pair.unitB : pair.unitA
    }

    var outputUnit: String {
        isReversed ? pair.unitA : pair.unitB
    }

    var outputText: String {
        guard let inputValue = NumericInputParser.parse(inputText) else {
            return "--"
        }

        let outputValue = pair.convert(inputValue, isReversed: isReversed)
        return NumberFormatting.display(outputValue)
    }

    func swapUnits() {
        isReversed.toggle()
    }
}
