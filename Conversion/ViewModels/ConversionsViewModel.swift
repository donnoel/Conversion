import Combine
import Foundation

@MainActor
final class ConversionsViewModel: ObservableObject {
    let categories: [ConversionCategory]

    init(categories: [ConversionCategory] = ConversionCategory.allCases) {
        self.categories = categories
    }

    func pairs(for category: ConversionCategory) -> [ConversionPair] {
        ConversionCatalog.pairs(for: category)
    }
}
