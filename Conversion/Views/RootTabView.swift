import SwiftUI

struct RootTabView: View {
    @StateObject private var favoritesStore = FavoritesStore()
    @StateObject private var conversionsViewModel = ConversionsViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                ConversionsTabView(viewModel: conversionsViewModel)
            }
            .tabItem {
                Label("Conversions", systemImage: "arrow.left.arrow.right")
            }

            NavigationStack {
                FavoritesTabView()
            }
            .tabItem {
                Label("Favorites", systemImage: "star")
            }
        }
        .tint(LiquidGlassTheme.tint)
        .environmentObject(favoritesStore)
    }
}

#Preview {
    RootTabView()
}
