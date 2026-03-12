import Combine
import Foundation

enum RootTab: String, Sendable {
    case conversions
    case favorites
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

    private let defaults: UserDefaults
    private let selectedTabKey = "session.selectedTab.v1"
    private let selectedGroupIDKey = "session.selectedGroupID.v1"
    private let searchTextKey = "session.searchText.v1"
    private let converterStateKey = "session.converterStates.v1"
    private var converterStates: [String: ConverterSessionState]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if ProcessInfo.processInfo.arguments.contains("-ui-testing-reset-state") {
            defaults.removeObject(forKey: selectedTabKey)
            defaults.removeObject(forKey: selectedGroupIDKey)
            defaults.removeObject(forKey: searchTextKey)
            defaults.removeObject(forKey: converterStateKey)
        }

        if
            let rawTab = defaults.string(forKey: selectedTabKey),
            let restoredTab = RootTab(rawValue: rawTab)
        {
            selectedTab = restoredTab
        } else {
            selectedTab = .conversions
        }

        selectedGroupID = defaults.string(forKey: selectedGroupIDKey) ?? ""
        searchText = defaults.string(forKey: searchTextKey) ?? ""

        if
            let data = defaults.data(forKey: converterStateKey),
            let decoded = try? JSONDecoder().decode([String: ConverterSessionState].self, from: data)
        {
            converterStates = decoded
        } else {
            converterStates = [:]
        }
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
}
