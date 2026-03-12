import XCTest
@testable import Conversion

@MainActor
final class SessionStateStoreTests: XCTestCase {
    func testRestoresSavedBrowsingAndTabState() {
        let defaults = makeDefaults()
        defaults.set(RootTab.favorites.rawValue, forKey: "session.selectedTab.v1")
        defaults.set("all", forKey: "session.selectedGroupID.v1")
        defaults.set("meters", forKey: "session.searchText.v1")

        let store = SessionStateStore(defaults: defaults)

        XCTAssertEqual(store.selectedTab, .favorites)
        XCTAssertEqual(store.selectedGroupID, "all")
        XCTAssertEqual(store.searchText, "meters")
    }

    func testPersistsAndRestoresConverterSessionState() {
        let defaults = makeDefaults()

        let store = SessionStateStore(defaults: defaults)
        store.setConverterState(
            ConverterSessionState(inputText: "25.5", isReversed: true),
            for: "length.cm-in"
        )

        let restoredStore = SessionStateStore(defaults: defaults)
        XCTAssertEqual(
            restoredStore.converterState(for: "length.cm-in"),
            ConverterSessionState(inputText: "25.5", isReversed: true)
        )
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "SessionStateStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
