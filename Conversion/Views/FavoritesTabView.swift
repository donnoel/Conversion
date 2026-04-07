import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct FavoritesTabView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var favoritesStore: FavoritesStore

    private var columns: [GridItem] {
        let isRegular = horizontalSizeClass == .regular
        let count = isRegular ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .top), count: count)
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
                .accessibilityIdentifier("favorites.empty")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: LiquidGlassTheme.sectionSpacing) {
                        heroHeader

                        LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                            ForEach(favoritePairs) { pair in
                                ConverterCardView(pair: pair)
                                    .accessibilityIdentifier("favorites.card.\(pair.id)")
                            }
                        }
                    }
                    .frame(maxWidth: LiquidGlassTheme.contentWidth, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                .scrollDismissesKeyboard(.immediately)
                .accessibilityIdentifier("favorites.list")
            }
        }
        .navigationTitle("Favorites")
        .background {
            ZStack {
                LiquidGlassTheme.canvasGradient(for: colorScheme)
                    .ignoresSafeArea()

                Rectangle()
                    .fill(LiquidGlassTheme.screenGlow(for: colorScheme))
                    .ignoresSafeArea()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
            }
        }
    }

    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Your saved converters")
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.98) : .primary)

                Spacer(minLength: 8)

                Text("\(favoritePairs.count)")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.88) : .primary.opacity(0.75))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .accessibilityLabel("\(favoritePairs.count) favorite converters")
            }

            Text("Keep your most-used conversions close at hand.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.72) : .primary.opacity(0.72))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: LiquidGlassTheme.cardCornerRadius, style: .continuous)
                .fill(LiquidGlassTheme.heroBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: LiquidGlassTheme.cardCornerRadius, style: .continuous)
                .strokeBorder(LiquidGlassTheme.cardStroke(for: colorScheme), lineWidth: 0.7)
        )
    }

    private func dismissKeyboard() {
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
}

#Preview {
    NavigationStack {
        FavoritesTabView()
            .environmentObject(FavoritesStore())
            .environmentObject(SessionStateStore())
    }
}
