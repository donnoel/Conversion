import Combine
import Foundation

actor FavoritesPersistenceService {
    private let defaults: UserDefaults
    private let favoritesKey = "favoriteConversionPairIDs.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if ProcessInfo.processInfo.arguments.contains("-ui-testing-reset-state") {
            defaults.removeObject(forKey: favoritesKey)
        }
    }

    func loadFavorites() -> Set<String> {
        Set(defaults.stringArray(forKey: favoritesKey) ?? [])
    }

    func saveFavorites(_ favorites: Set<String>) {
        defaults.set(favorites.sorted(), forKey: favoritesKey)
    }
}

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteIDs: Set<String> = []

    private let persistence: FavoritesPersistenceService
    private var loadTask: Task<Void, Never>?
    private var saveTask: Task<Void, Never>?

    init(persistence: FavoritesPersistenceService = FavoritesPersistenceService()) {
        self.persistence = persistence
        loadTask = Task { [weak self] in
            guard let self else { return }
            let ids = await persistence.loadFavorites()
            self.favoriteIDs.formUnion(ids)
        }
    }

    deinit {
        loadTask?.cancel()
        saveTask?.cancel()
    }

    func isFavorite(pairID: String) -> Bool {
        favoriteIDs.contains(pairID)
    }

    func toggle(pairID: String) {
        if favoriteIDs.contains(pairID) {
            favoriteIDs.remove(pairID)
        } else {
            favoriteIDs.insert(pairID)
        }

        scheduleSave()
    }

    private func scheduleSave() {
        saveTask?.cancel()
        let snapshot = favoriteIDs

        saveTask = Task {
            await persistence.saveFavorites(snapshot)
        }
    }
}
