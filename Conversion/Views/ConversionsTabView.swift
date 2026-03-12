import SwiftUI

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme

    private var columns: [GridItem] {
        let isRegular = horizontalSizeClass == .regular
        let count = isRegular ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 14, alignment: .top), count: count)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                searchField
                groupPicker

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(viewModel.visibleSectionTitle)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.95) : .primary)

                        if viewModel.isSearching {
                            Text("\(viewModel.visiblePairs.count)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(.thinMaterial)
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .accessibilityLabel("\(viewModel.visiblePairs.count) results")
                        }
                    }

                    if viewModel.visiblePairs.isEmpty {
                        ContentUnavailableView(
                            "No Matches",
                            systemImage: "magnifyingglass",
                            description: Text("Try a different search term.")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                            ForEach(viewModel.visiblePairs) { pair in
                                ConverterCardView(pair: pair)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: 960, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .navigationTitle("Conversions")
        .background(LiquidGlassTheme.canvasGradient(for: colorScheme).ignoresSafeArea())
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.subheadline.weight(.semibold))

            TextField("Search conversions", text: $viewModel.searchText)
                .font(.body.weight(.medium))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .accessibilityLabel("Search conversions")
                .accessibilityHint("Search by converter name, unit, or category")
                .accessibilityIdentifier("conversions.searchField")

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
                .accessibilityIdentifier("conversions.clearSearch")
            }
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 12)
        .liquidGlassSurfaceStyle(cornerRadius: 16)
    }

    private var groupPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.groups, id: \.id) { group in
                    let isSelected = viewModel.selectedGroup == group

                    Button {
                        viewModel.selectedGroup = group
                    } label: {
                        Text(group.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(isSelected ? .white : .primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .frame(minHeight: 44)
                            .background(
                                Group {
                                    if isSelected {
                                        Capsule()
                                            .fill(LiquidGlassTheme.tint.gradient)
                                            .shadow(color: LiquidGlassTheme.tint.opacity(0.35), radius: 8, x: 0, y: 4)
                                    } else {
                                        Capsule()
                                            .fill(.thinMaterial)
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                                            )
                                    }
                                }
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(group.title) group")
                    .accessibilityValue(isSelected ? "Selected" : "Not selected")
                    .accessibilityHint(isSelected ? "Current group" : "Shows \(group.title) converters")
                    .accessibilityIdentifier("conversions.group.\(group.id)")
                }
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
        }
        .accessibilityLabel("Conversion groups")
    }
}

#Preview {
    NavigationStack {
        ConversionsTabView(viewModel: ConversionsViewModel())
            .environmentObject(FavoritesStore())
            .environmentObject(SessionStateStore())
    }
}
