import Foundation

enum ConversionBrowseGroup: Hashable, Identifiable, Sendable {
    case all
    case category(ConversionCategory)

    var id: String {
        switch self {
        case .all:
            "all"
        case let .category(category):
            "category.\(category.rawValue)"
        }
    }

    var title: String {
        switch self {
        case .all:
            "All"
        case let .category(category):
            category.title
        }
    }

    static func orderedGroups(from categories: [ConversionCategory]) -> [ConversionBrowseGroup] {
        let sortedCategories = categories.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }

        return [.all] + sortedCategories.map(ConversionBrowseGroup.category)
    }

    static func from(
        id: String,
        availableCategories categories: [ConversionCategory]
    ) -> ConversionBrowseGroup? {
        if id == ConversionBrowseGroup.all.id {
            return .all
        }

        guard id.hasPrefix("category.") else { return nil }
        let categoryID = String(id.dropFirst("category.".count))
        guard let category = categories.first(where: { $0.rawValue == categoryID }) else {
            return nil
        }

        return .category(category)
    }
}
