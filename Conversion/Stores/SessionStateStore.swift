import Combine
import Foundation

enum RootTab: String, Sendable {
    case conversions
    case units
}

struct ConverterSessionState: Codable, Equatable, Sendable {
    var inputText: String
    var isReversed: Bool
}

@MainActor
final class SessionStateStore: ObservableObject {
    @Published var selectedTab: RootTab {
        didSet { defaults.set(selectedTab.rawValue, forKey: selectedTabKey) }
    }

    @Published var selectedGroupID: String {
        didSet { defaults.set(selectedGroupID, forKey: selectedGroupIDKey) }
    }

    @Published var searchText: String {
        didSet { defaults.set(searchText, forKey: searchTextKey) }
    }

    @Published var lastUsedPairID: String {
        didSet { defaults.set(lastUsedPairID, forKey: lastUsedPairIDKey) }
    }

    private let defaults: UserDefaults
    private let selectedTabKey = "session.selectedTab.v1"
    private let selectedGroupIDKey = "session.selectedGroupID.v1"
    private let searchTextKey = "session.searchText.v1"
    private let lastUsedPairIDKey = "session.lastUsedPairID.v1"
    private let converterStateKey = "session.converterStates.v1"
    private var converterStates: [String: ConverterSessionState]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        let arguments = ProcessInfo.processInfo.arguments

        if arguments.contains("-ui-testing-reset-state") {
            defaults.removeObject(forKey: selectedTabKey)
            defaults.removeObject(forKey: selectedGroupIDKey)
            defaults.removeObject(forKey: searchTextKey)
            defaults.removeObject(forKey: lastUsedPairIDKey)
            defaults.removeObject(forKey: converterStateKey)
        }

        if let rawTab = defaults.string(forKey: selectedTabKey) {
            if let restoredTab = RootTab(rawValue: rawTab) {
                selectedTab = restoredTab
            } else if rawTab == "favorites" {
                selectedTab = .units
            } else {
                selectedTab = .conversions
            }
        } else {
            selectedTab = .conversions
        }

        selectedGroupID = defaults.string(forKey: selectedGroupIDKey) ?? ""
        searchText = defaults.string(forKey: searchTextKey) ?? ""
        lastUsedPairID = defaults.string(forKey: lastUsedPairIDKey) ?? ""

        if
            let data = defaults.data(forKey: converterStateKey),
            let decoded = try? JSONDecoder().decode([String: ConverterSessionState].self, from: data)
        {
            converterStates = decoded
        } else {
            converterStates = [:]
        }

        applyUITestingSeedIfNeeded(arguments: arguments)
    }

    func converterState(for pairID: String) -> ConverterSessionState? {
        converterStates[pairID]
    }

    func setConverterState(_ state: ConverterSessionState, for pairID: String) {
        converterStates[pairID] = state
        saveConverterStates()
    }

    private func saveConverterStates() {
        guard let data = try? JSONEncoder().encode(converterStates) else { return }
        defaults.set(data, forKey: converterStateKey)
    }

    private func applyUITestingSeedIfNeeded(arguments: [String]) {
        guard let seedIndex = arguments.firstIndex(of: "-ui-testing-seed-converter") else {
            return
        }
        guard arguments.count > seedIndex + 2 else { return }

        let pairID = arguments[seedIndex + 1]
        let inputText = arguments[seedIndex + 2]

        var state = converterStates[pairID] ?? ConverterSessionState(inputText: "", isReversed: false)
        state.inputText = inputText
        converterStates[pairID] = state
        saveConverterStates()
        lastUsedPairID = pairID
    }
}
