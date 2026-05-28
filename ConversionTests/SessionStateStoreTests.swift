import XCTest
@testable import Conversion

@MainActor
final class SessionStateStoreTests: XCTestCase {
    func testRestoresSavedBrowsingAndTabState() {
        let defaults = makeDefaults()
        defaults.set(RootTab.units.rawValue, forKey: "session.selectedTab.v1")
        defaults.set("all", forKey: "session.selectedGroupID.v1")
        defaults.set("meters", forKey: "session.searchText.v1")
        defaults.set("speed.mph-kph", forKey: "session.lastUsedPairID.v1")

        let store = SessionStateStore(defaults: defaults)

        XCTAssertEqual(store.selectedTab, .units)
        XCTAssertEqual(store.selectedGroupID, "all")
        XCTAssertEqual(store.searchText, "meters")
        XCTAssertEqual(store.lastUsedPairID, "speed.mph-kph")
    }

    func testRestoresToolkitTabState() {
        let defaults = makeDefaults()
        defaults.set(RootTab.toolkit.rawValue, forKey: "session.selectedTab.v1")

        let store = SessionStateStore(defaults: defaults)
        XCTAssertEqual(store.selectedTab, .toolkit)
    }

    func testMigratesOldFavoritesTabStateToUnits() {
        let defaults = makeDefaults()
        defaults.set("favorites", forKey: "session.selectedTab.v1")

        let store = SessionStateStore(defaults: defaults)
        XCTAssertEqual(store.selectedTab, .units)
    }

    func testClearsPersistedConverterInputOnRelaunch() {
        let defaults = makeDefaults()

        let store = SessionStateStore(defaults: defaults)
        store.setConverterState(
            ConverterSessionState(inputText: "25.5", isReversed: true),
            for: "length.cm-in"
        )

        let restoredStore = SessionStateStore(defaults: defaults)
        XCTAssertEqual(
            restoredStore.converterState(for: "length.cm-in"),
            ConverterSessionState(inputText: "", isReversed: true)
        )
    }

    func testRecordsRecentPairsMostRecentFirstAndCapsList() {
        let defaults = makeDefaults()
        let store = SessionStateStore(defaults: defaults)

        [
            "length.cm-in",
            "weight.kg-lb",
            "temp.c-f",
            "volume.tsp-ml",
            "speed.mph-kph",
            "pressure.psi-bar",
            "temp.c-f"
        ].forEach(store.recordRecentPairID)

        XCTAssertEqual(
            store.recentPairIDs,
            ["temp.c-f", "pressure.psi-bar", "speed.mph-kph", "volume.tsp-ml", "weight.kg-lb"]
        )

        let restoredStore = SessionStateStore(defaults: defaults)
        XCTAssertEqual(restoredStore.recentPairIDs, store.recentPairIDs)
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "SessionStateStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
