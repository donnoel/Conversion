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
            ["All", "Angle", "Area", "Length", "Power", "Pressure", "Speed", "Temperature", "Volume", "Weight / Mass"]
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
        XCTAssertEqual(visibleIDs, ["length.cm-in", "length.cm-ft", "length.m-cm"])
    }

    func testSearchMatchesCategoryTitle() {
        let viewModel = ConversionsViewModel()
        viewModel.searchText = "volume"

        let visibleIDs = Set(viewModel.visiblePairs.map(\.id))
        XCTAssertEqual(visibleIDs, ["volume.floz-ml", "volume.l-gal", "volume.ml-cup", "volume.pt-l", "volume.qt-l", "volume.tbsp-ml", "volume.tsp-ml"])
    }

    func testSearchMatchesNewUnitSymbolsNaturally() {
        let viewModel = ConversionsViewModel()
        viewModel.searchText = "tsp"

        XCTAssertEqual(viewModel.visiblePairs.map(\.id), ["volume.tsp-ml"])
    }

    func testSearchMatchesPressureSymbolsNaturally() {
        let viewModel = ConversionsViewModel()
        viewModel.searchText = "psi"

        XCTAssertEqual(Set(viewModel.visiblePairs.map(\.id)), ["pressure.psi-bar", "pressure.psi-kpa"])
    }

    func testClearingSearchReturnsToSelectedCategory() {
        let viewModel = ConversionsViewModel()
        viewModel.selectedGroup = .category(.temperature)
        viewModel.searchText = "feet"
        XCTAssertTrue(viewModel.isSearching)

        viewModel.searchText = ""

        XCTAssertFalse(viewModel.isSearching)
        XCTAssertEqual(Set(viewModel.visiblePairs.map(\.id)), ["temp.c-f", "temp.c-k"])
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

    func testViewModelClearsRestoredInputValueOnRelaunch() {
        let defaults = makeDefaults()
        defaults.set("speed.mph-kph", forKey: "session.lastUsedPairID.v1")

        let state = ["speed.mph-kph": ConverterSessionState(inputText: "10", isReversed: true)]
        let encodedState = try! JSONEncoder().encode(state)
        defaults.set(encodedState, forKey: "session.converterStates.v1")

        let sessionStore = SessionStateStore(defaults: defaults)
        let viewModel = ConversionsViewModel(sessionStateStore: sessionStore)

        XCTAssertEqual(viewModel.selectedPairID, "speed.mph-kph")
        XCTAssertEqual(viewModel.inputText, "")
        XCTAssertFalse(viewModel.isReversed)
    }

    func testSpeedConverterAlwaysOpensAsKphToMph() {
        let defaults = makeDefaults()
        defaults.set("speed.mph-kph", forKey: "session.lastUsedPairID.v1")

        let state = ["speed.mph-kph": ConverterSessionState(inputText: "", isReversed: false)]
        let encodedState = try! JSONEncoder().encode(state)
        defaults.set(encodedState, forKey: "session.converterStates.v1")

        let sessionStore = SessionStateStore(defaults: defaults)
        let viewModel = ConversionsViewModel(sessionStateStore: sessionStore)

        XCTAssertEqual(viewModel.selectedPairID, "speed.mph-kph")
        XCTAssertFalse(viewModel.isReversed)
        XCTAssertEqual(viewModel.inputUnit, "kph")
        XCTAssertEqual(viewModel.outputUnit, "mph")
    }

    func testLengthUnitPickerSectionIncludesNewPairsAlphabetically() {
        let viewModel = ConversionsViewModel()

        let lengthSection = try! XCTUnwrap(viewModel.unitPickerSections.first(where: { $0.category == .length }))
        let lengthIDs = lengthSection.pairs.map(\.id)

        XCTAssertTrue(lengthIDs.contains("length.m-cm"))
        XCTAssertTrue(lengthIDs.contains("length.mi-ft"))
        XCTAssertEqual(lengthSection.pairs.first?.id, "length.cm-ft")
    }

    func testPressureUnitPickerSectionAppearsInAlphabeticalCategoryOrder() throws {
        let viewModel = ConversionsViewModel()

        let pressureSection = try XCTUnwrap(viewModel.unitPickerSections.first(where: { $0.category == .pressure }))

        XCTAssertEqual(pressureSection.pairs.map(\.id), ["pressure.bar-kpa", "pressure.psi-bar", "pressure.psi-kpa"])
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "ConversionsViewModelTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
