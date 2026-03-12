import Foundation
import XCTest
@testable import Conversion

@MainActor
final class ConversionsViewModelTests: XCTestCase {
    func testDefaultSelectedGroupIsLengthCategory() {
        let viewModel = ConversionsViewModel()
        XCTAssertEqual(viewModel.selectedGroup, .category(.length))
    }

    func testGroupsOrderHasAllFirstThenAlphabetizedCategories() {
        let viewModel = ConversionsViewModel()
        XCTAssertEqual(
            viewModel.groups.map(\.title),
            ["All", "Angle", "Area", "Length", "Power", "Speed", "Temperature", "Volume", "Weight / Mass"]
        )
    }

    func testVisiblePairsUsesSelectedGroupWhenSearchIsEmpty() {
        let viewModel = ConversionsViewModel()
        viewModel.selectedGroup = .category(.power)

        let visibleIDs = Set(viewModel.visiblePairs.map(\.id))
        XCTAssertEqual(visibleIDs, ["power.hp-kw"])
    }

    func testVisiblePairsIncludesAllPairsWhenAllGroupIsSelectedAndSearchIsEmpty() {
        let viewModel = ConversionsViewModel()
        viewModel.selectedGroup = .all

        XCTAssertEqual(viewModel.visiblePairs.count, ConversionCatalog.allPairs.count)
        XCTAssertEqual(Set(viewModel.visiblePairs.map(\.id)), Set(ConversionCatalog.allPairs.map(\.id)))
    }

    func testSearchFiltersAcrossFullCatalogNotJustSelectedCategory() {
        let viewModel = ConversionsViewModel()
        viewModel.selectedGroup = .category(.power)
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
        viewModel.selectedGroup = .category(.temperature)
        viewModel.searchText = "feet"
        XCTAssertTrue(viewModel.isSearching)

        viewModel.searchText = ""

        XCTAssertFalse(viewModel.isSearching)
        XCTAssertEqual(Set(viewModel.visiblePairs.map(\.id)), ["temp.c-f"])
    }

    func testViewModelRestoresSelectedGroupAndSearchFromSessionStore() {
        let defaults = makeDefaults()
        defaults.set("all", forKey: "session.selectedGroupID.v1")
        defaults.set("speed", forKey: "session.searchText.v1")
        let sessionStore = SessionStateStore(defaults: defaults)

        let viewModel = ConversionsViewModel(sessionStateStore: sessionStore)

        XCTAssertEqual(viewModel.selectedGroup, .all)
        XCTAssertEqual(viewModel.searchText, "speed")
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "ConversionsViewModelTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
