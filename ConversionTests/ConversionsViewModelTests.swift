import XCTest
@testable import Conversion

@MainActor
final class ConversionsViewModelTests: XCTestCase {
    func testDefaultSelectedCategoryIsLength() {
        let viewModel = ConversionsViewModel()
        XCTAssertEqual(viewModel.selectedCategory, .length)
    }

    func testVisiblePairsUsesSelectedCategoryWhenSearchIsEmpty() {
        let viewModel = ConversionsViewModel()
        viewModel.selectedCategory = .power

        let visibleIDs = Set(viewModel.visiblePairs.map(\.id))
        XCTAssertEqual(visibleIDs, ["power.hp-kw"])
    }

    func testSearchFiltersAcrossFullCatalogNotJustSelectedCategory() {
        let viewModel = ConversionsViewModel()
        viewModel.selectedCategory = .power
        viewModel.searchText = "cm"

        let visibleIDs = Set(viewModel.visiblePairs.map(\.id))
        XCTAssertEqual(visibleIDs, ["length.cm-in", "length.cm-ft"])
    }

    func testSearchMatchesCategoryTitle() {
        let viewModel = ConversionsViewModel()
        viewModel.searchText = "volume"

        let visibleIDs = Set(viewModel.visiblePairs.map(\.id))
        XCTAssertEqual(visibleIDs, ["volume.l-gal", "volume.ml-cup"])
    }

    func testClearingSearchReturnsToSelectedCategory() {
        let viewModel = ConversionsViewModel()
        viewModel.selectedCategory = .temperature
        viewModel.searchText = "feet"
        XCTAssertTrue(viewModel.isSearching)

        viewModel.searchText = ""

        XCTAssertFalse(viewModel.isSearching)
        XCTAssertEqual(Set(viewModel.visiblePairs.map(\.id)), ["temp.c-f"])
    }
}
