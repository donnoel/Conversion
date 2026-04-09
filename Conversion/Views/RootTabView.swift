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
                Label("Conversion", systemImage: "arrow.left.arrow.right")
            }

            NavigationStack {
                UnitsTabView(viewModel: conversionsViewModel)
            }
            .tag(RootTab.units)
            .tabItem {
                Label("Units", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                ToolkitTabView()
            }
            .tag(RootTab.toolkit)
            .tabItem {
                Label("Toolkit", systemImage: "wrench.and.screwdriver")
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
