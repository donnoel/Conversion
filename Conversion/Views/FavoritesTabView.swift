import SwiftUI

struct FavoritesTabView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var favoritesStore: FavoritesStore

    private var columns: [GridItem] {
        let isRegular = horizontalSizeClass == .regular
        let count = isRegular ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 14, alignment: .top), count: count)
    }

    private var favoritePairs: [ConversionPair] {
        ConversionCatalog.allPairs.filter { favoritesStore.favoriteIDs.contains($0.id) }
    }

    var body: some View {
        Group {
            if favoritePairs.isEmpty {
                ContentUnavailableView(
                    "No Favorites Yet",
                    systemImage: "star",
                    description: Text("Tap the star on any converter to add it here.")
                )
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.92) : .primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                        ForEach(favoritePairs) { pair in
                            ConverterCardView(pair: pair)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationTitle("Favorites")
        .background(LiquidGlassTheme.canvasGradient(for: colorScheme).ignoresSafeArea())
    }
}

#Preview {
    NavigationStack {
        FavoritesTabView()
            .environmentObject(FavoritesStore())
    }
}
