import SwiftUI

struct UnitsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @EnvironmentObject private var sessionStateStore: SessionStateStore

    private var favoritePairs: [ConversionPair] {
        let candidates = viewModel.isSearching ? viewModel.unitPickerSearchResults : viewModel.allPairs
        return candidates
            .filter { favoritesStore.isFavorite(pairID: $0.id) }
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    var body: some View {
        let favoriteIDs = Set(favoritePairs.map(\.id))
        let searchResults = viewModel.isSearching
            ? viewModel.unitPickerSearchResults.filter { !favoriteIDs.contains($0.id) }
            : []

        List {
            if !favoritePairs.isEmpty {
                Section("Favorites") {
                    pairRows(favoritePairs)
                }
            }

            if viewModel.isSearching {
                if !searchResults.isEmpty {
                    Section("Search Results") {
                        pairRows(searchResults)
                    }
                }
            } else {
                let sections = viewModel.unitPickerSections.compactMap { section -> (category: ConversionCategory, pairs: [ConversionPair])? in
                    let remainingPairs = section.pairs.filter { !favoriteIDs.contains($0.id) }
                    guard !remainingPairs.isEmpty else { return nil }
                    return (section.category, remainingPairs)
                }

                ForEach(sections, id: \.category) { section in
                    Section(section.category.title) {
                        pairRows(section.pairs)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(LiquidGlassTheme.gentleCanvasGradient(for: colorScheme))
        .overlay {
            if viewModel.isSearching && favoriteIDs.isEmpty && searchResults.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchText)
            }
        }
        .navigationTitle("Units")
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search units")
    }

    @ViewBuilder
    private func pairRows(_ pairs: [ConversionPair]) -> some View {
        ForEach(pairs) { pair in
            HStack(spacing: 12) {
                Button {
                    viewModel.selectPair(pair)
                    sessionStateStore.selectedTab = .conversions
                } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(pair.displayTitle)
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .foregroundStyle(.primary)

                            if pair.id == viewModel.selectedPairID {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(.caption, design: .rounded).weight(.semibold))
                                    .foregroundStyle(LiquidGlassTheme.tint)
                                    .accessibilityHidden(true)
                            }
                        }

                        Text("\(pair.unitA) ↔ \(pair.unitB)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Choose \(pair.spokenTitle)")
                .accessibilityHint("Opens this converter on the home screen")
                .accessibilityAddTraits(pair.id == viewModel.selectedPairID ? .isSelected : [])
                .accessibilityIdentifier("units.row.\(pair.id)")

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
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(colorScheme == .dark ? 0.10 : 0.52))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(favoriteAccessibilityLabel(for: pair))
                .accessibilityIdentifier("units.favorite.\(pair.id)")
            }
        }
    }

    private func favoriteAccessibilityLabel(for pair: ConversionPair) -> String {
        let pairName = pair.spokenTitle
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
