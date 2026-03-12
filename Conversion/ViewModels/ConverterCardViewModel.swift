import Combine
import Foundation

@MainActor
final class ConverterCardViewModel: ObservableObject {
    let pair: ConversionPair

    @Published var inputText: String = "" {
        didSet { persistState() }
    }
    @Published private(set) var isReversed: Bool = false {
        didSet { persistState() }
    }

    private var sessionStateStore: SessionStateStore?
    private var hasLoadedPersistedState = false

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

    func connectSessionStateStore(_ sessionStateStore: SessionStateStore) {
        guard self.sessionStateStore == nil else { return }
        self.sessionStateStore = sessionStateStore

        guard !hasLoadedPersistedState else { return }
        hasLoadedPersistedState = true

        guard let restoredState = sessionStateStore.converterState(for: pair.id) else { return }
        inputText = restoredState.inputText
        isReversed = restoredState.isReversed
    }

    private func persistState() {
        guard let sessionStateStore else { return }
        let state = ConverterSessionState(inputText: inputText, isReversed: isReversed)
        sessionStateStore.setConverterState(state, for: pair.id)
    }
}
