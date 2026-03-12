import SwiftUI

struct RootTabView: View {
    @StateObject private var favoritesStore = FavoritesStore()
    @StateObject private var sessionStateStore: SessionStateStore
    @StateObject private var conversionsViewModel: ConversionsViewModel

    init() {
        let sessionStateStore = SessionStateStore()
        _sessionStateStore = StateObject(wrappedValue: sessionStateStore)
        _conversionsViewModel = StateObject(
            wrappedValue: ConversionsViewModel(sessionStateStore: sessionStateStore)
        )
    }

    var body: some View {
        TabView(selection: $sessionStateStore.selectedTab) {
            NavigationStack {
                ConversionsTabView(viewModel: conversionsViewModel)
            }
            .tag(RootTab.conversions)
            .tabItem {
                Label("Conversions", systemImage: "arrow.left.arrow.right")
            }

            NavigationStack {
                FavoritesTabView()
            }
            .tag(RootTab.favorites)
            .tabItem {
                Label("Favorites", systemImage: "star")
            }
        }
        .tint(LiquidGlassTheme.tint)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .environmentObject(favoritesStore)
        .environmentObject(sessionStateStore)
    }
}

#Preview {
    RootTabView()
}
