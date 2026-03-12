import Combine
import Foundation

@MainActor
final class ConversionsViewModel: ObservableObject {
    let allPairs: [ConversionPair]
    let groups: [ConversionBrowseGroup]

    @Published var selectedGroup: ConversionBrowseGroup {
        didSet {
            sessionStateStore?.selectedGroupID = selectedGroup.id
        }
    }

    @Published var searchText: String {
        didSet {
            sessionStateStore?.searchText = searchText
        }
    }

    @Published var selectedPairID: String {
        didSet {
            loadStateForSelectedPair()
        }
    }

    @Published var inputText: String = "" {
        didSet {
            persistSelectedPairState()
        }
    }

    @Published private(set) var isReversed: Bool = false {
        didSet {
            persistSelectedPairState()
        }
    }

    private let sessionStateStore: SessionStateStore?
    private var isRestoringPairState = false

    init(
        categories: [ConversionCategory] = ConversionCategory.allCases,
        defaultCategory: ConversionCategory = .length,
        sessionStateStore: SessionStateStore? = nil
    ) {
        self.allPairs = ConversionCatalog.allPairs
        self.groups = ConversionBrowseGroup.orderedGroups(from: categories)
        self.sessionStateStore = sessionStateStore

        if
            let store = sessionStateStore,
            let restoredGroup = ConversionBrowseGroup.from(id: store.selectedGroupID, availableCategories: categories),
            groups.contains(restoredGroup)
        {
            self.selectedGroup = restoredGroup
        } else {
            let fallbackCategory = categories.contains(defaultCategory) ? defaultCategory : (categories.first ?? .length)
            self.selectedGroup = .category(fallbackCategory)
        }

        self.searchText = sessionStateStore?.searchText ?? ""
        self.selectedPairID = Self.initialPairID(
            from: sessionStateStore?.lastUsedPairID,
            allPairs: allPairs
        )
        loadStateForSelectedPair()
    }

    func pairs(for group: ConversionBrowseGroup) -> [ConversionPair] {
        switch group {
        case .all:
            return allPairs
        case let .category(category):
            return allPairs.filter { $0.category == category }
        }
    }

    var isSearching: Bool {
        !normalizedSearchText.isEmpty
    }

    var visiblePairs: [ConversionPair] {
        guard isSearching else {
            return pairs(for: selectedGroup)
        }

        return allPairs.filter(matchesSearch)
    }

    var visibleSectionTitle: String {
        isSearching ? "Search Results" : selectedGroup.title
    }

    var selectedPair: ConversionPair {
        allPairs.first(where: { $0.id == selectedPairID }) ?? allPairs[0]
    }

    var inputUnit: String {
        isReversed ? selectedPair.unitB : selectedPair.unitA
    }

    var outputUnit: String {
        isReversed ? selectedPair.unitA : selectedPair.unitB
    }

    var outputText: String {
        guard let inputValue = NumericInputParser.parse(inputText) else {
            return "--"
        }

        let outputValue = selectedPair.convert(inputValue, isReversed: isReversed)
        return NumberFormatting.display(outputValue)
    }

    var unitPickerSections: [(category: ConversionCategory, pairs: [ConversionPair])] {
        let categories = ConversionCategory.allCases.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }

        return categories.compactMap { category in
            let categoryPairs = allPairs
                .filter { $0.category == category }
                .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
            guard !categoryPairs.isEmpty else { return nil }
            return (category, categoryPairs)
        }
    }

    var unitPickerSearchResults: [ConversionPair] {
        allPairs
            .filter(matchesSearch)
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    func swapUnits() {
        isReversed.toggle()
    }

    func selectPair(_ pair: ConversionPair) {
        guard selectedPairID != pair.id else { return }
        sessionStateStore?.lastUsedPairID = pair.id
        selectedPairID = pair.id
    }

    private var normalizedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func matchesSearch(_ pair: ConversionPair) -> Bool {
        let query = normalizedSearchText
        guard !query.isEmpty else { return true }

        return pair.title.lowercased().contains(query)
            || pair.unitA.lowercased().contains(query)
            || pair.unitB.lowercased().contains(query)
            || pair.category.title.lowercased().contains(query)
    }

    private func loadStateForSelectedPair() {
        guard allPairs.contains(where: { $0.id == selectedPairID }) else {
            selectedPairID = allPairs[0].id
            return
        }

        let restoredState = sessionStateStore?.converterState(for: selectedPairID)
            ?? ConverterSessionState(inputText: "", isReversed: false)

        isRestoringPairState = true
        inputText = restoredState.inputText
        isReversed = preferredInitialDirection(for: selectedPairID, restoredIsReversed: restoredState.isReversed)
        isRestoringPairState = false
    }

    private func persistSelectedPairState() {
        guard !isRestoringPairState, let sessionStateStore else { return }
        let state = ConverterSessionState(inputText: inputText, isReversed: isReversed)
        sessionStateStore.setConverterState(state, for: selectedPairID)
        sessionStateStore.lastUsedPairID = selectedPairID
    }

    private static func initialPairID(from restoredPairID: String?, allPairs: [ConversionPair]) -> String {
        if let restoredPairID, allPairs.contains(where: { $0.id == restoredPairID }) {
            return restoredPairID
        }

        if let lengthPair = allPairs.first(where: { $0.id == "length.cm-in" }) {
            return lengthPair.id
        }

        return allPairs[0].id
    }

    private func preferredInitialDirection(for pairID: String, restoredIsReversed: Bool) -> Bool {
        // Speed converter is intentionally biased to kph -> mph on open.
        if pairID == "speed.mph-kph" {
            return true
        }

        return restoredIsReversed
    }
}
