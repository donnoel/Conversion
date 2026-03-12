import Combine
import Foundation

@MainActor
final class ConversionsViewModel: ObservableObject {
    let categories: [ConversionCategory]
    @Published var selectedCategory: ConversionCategory
    @Published var searchText: String = ""

    init(
        categories: [ConversionCategory] = ConversionCategory.allCases,
        defaultCategory: ConversionCategory = .length
    ) {
        self.categories = categories
        self.selectedCategory = categories.contains(defaultCategory) ? defaultCategory : (categories.first ?? .length)
    }

    func pairs(for category: ConversionCategory) -> [ConversionPair] {
        ConversionCatalog.pairs(for: category)
    }

    var isSearching: Bool {
        !normalizedSearchText.isEmpty
    }

    var visiblePairs: [ConversionPair] {
        guard isSearching else {
            return pairs(for: selectedCategory)
        }

        return ConversionCatalog.allPairs.filter(matchesSearch)
    }

    var visibleSectionTitle: String {
        isSearching ? "Search Results" : selectedCategory.title
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
