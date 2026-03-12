import Combine
import Foundation

@MainActor
final class ConversionsViewModel: ObservableObject {
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

    private let sessionStateStore: SessionStateStore?

    init(
        categories: [ConversionCategory] = ConversionCategory.allCases,
        defaultCategory: ConversionCategory = .length,
        sessionStateStore: SessionStateStore? = nil
    ) {
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
    }

    func pairs(for group: ConversionBrowseGroup) -> [ConversionPair] {
        switch group {
        case .all:
            return ConversionCatalog.allPairs
        case let .category(category):
            return ConversionCatalog.pairs(for: category)
        }
    }

    var isSearching: Bool {
        !normalizedSearchText.isEmpty
    }

    var visiblePairs: [ConversionPair] {
        guard isSearching else {
            return pairs(for: selectedGroup)
        }

        return ConversionCatalog.allPairs.filter(matchesSearch)
    }

    var visibleSectionTitle: String {
        isSearching ? "Search Results" : selectedGroup.title
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
}
