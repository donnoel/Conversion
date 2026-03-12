import SwiftUI

struct UnitsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @EnvironmentObject private var sessionStateStore: SessionStateStore

    var body: some View {
        List {
            if viewModel.isSearching {
                Section("Search Results") {
                    pairRows(viewModel.unitPickerSearchResults)
                }
            } else {
                ForEach(viewModel.unitPickerSections, id: \.category) { section in
                    Section(section.category.title) {
                        pairRows(section.pairs)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(LiquidGlassTheme.gentleCanvasGradient(for: colorScheme))
        .navigationTitle("Units")
        .searchable(text: $viewModel.searchText, prompt: "Search units")
    }

    @ViewBuilder
    private func pairRows(_ pairs: [ConversionPair]) -> some View {
        ForEach(pairs) { pair in
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(pair.title)
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)

                        if pair.id == viewModel.selectedPairID {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(LiquidGlassTheme.tint)
                                .accessibilityHidden(true)
                        }
                    }

                    Text("\(pair.unitA) ↔ \(pair.unitB)")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Button {
                    favoritesStore.toggle(pairID: pair.id)
                } label: {
                    Image(systemName: favoritesStore.isFavorite(pairID: pair.id) ? "star.fill" : "star")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(
                            favoritesStore.isFavorite(pairID: pair.id)
                                ? LiquidGlassTheme.favoriteTint
                                : .secondary.opacity(0.75)
                        )
                        .frame(width: 34, height: 34)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(colorScheme == .dark ? 0.10 : 0.52))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(favoriteAccessibilityLabel(for: pair))
                .accessibilityIdentifier("units.favorite.\(pair.id)")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.selectPair(pair)
                sessionStateStore.selectedTab = .conversions
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Choose \(pair.title)")
            .accessibilityHint("Opens this converter on the home screen")
            .accessibilityIdentifier("units.row.\(pair.id)")
        }
    }

    private func favoriteAccessibilityLabel(for pair: ConversionPair) -> String {
        let pairName = pair.title.replacingOccurrences(of: "<->", with: "and")
        if favoritesStore.isFavorite(pairID: pair.id) {
            return "Remove \(pairName) from favorites"
        }
        return "Add \(pairName) to favorites"
    }
}

#Preview {
    NavigationStack {
        UnitsTabView(viewModel: ConversionsViewModel())
            .environmentObject(FavoritesStore())
            .environmentObject(SessionStateStore())
    }
}
