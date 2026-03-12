import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme

    private var columns: [GridItem] {
        let isRegular = horizontalSizeClass == .regular
        let count = isRegular ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .top), count: count)
    }

    private var visibleCountLabel: String {
        "\(viewModel.visiblePairs.count)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LiquidGlassTheme.sectionSpacing) {
                heroHeader
                searchField
                groupPicker
                sectionHeader
                visibleContent
            }
            .frame(maxWidth: LiquidGlassTheme.contentWidth, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Conversions")
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
                Text("Convert at a glance")
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.98) : .primary)

                Spacer(minLength: 8)

                Text(visibleCountLabel)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.88) : .primary.opacity(0.75))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .accessibilityLabel("\(viewModel.visiblePairs.count) visible converters")
            }

            Text("Quick, reversible unit conversion with a clean one-screen workflow.")
                .font(.subheadline)
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

    private var sectionHeader: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(viewModel.visibleSectionTitle)
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.95) : .primary)

            if viewModel.isSearching {
                Text("\(viewModel.visiblePairs.count) matches")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("\(viewModel.visiblePairs.count) search matches")
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 2)
    }

    @ViewBuilder
    private var visibleContent: some View {
        if viewModel.visiblePairs.isEmpty {
            ContentUnavailableView(
                "No Matches",
                systemImage: "magnifyingglass",
                description: Text("Try a different search term.")
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
        } else {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(viewModel.visiblePairs) { pair in
                    ConverterCardView(pair: pair)
                }
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            TextField("Search conversions", text: $viewModel.searchText)
                .font(.system(.body, design: .rounded))
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
                        .font(.subheadline)
                        .foregroundStyle(.secondary.opacity(0.9))
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
                .accessibilityIdentifier("conversions.clearSearch")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .liquidGlassSurfaceStyle(cornerRadius: LiquidGlassTheme.controlCornerRadius)
    }

    private var groupPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(viewModel.groups, id: \.id) { group in
                    let isSelected = viewModel.selectedGroup == group

                    Button {
                        viewModel.selectedGroup = group
                    } label: {
                        Text(group.title)
                            .font(.system(.subheadline, design: .rounded).weight(isSelected ? .semibold : .medium))
                            .foregroundStyle(isSelected ? LiquidGlassTheme.tint : .secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(
                                RoundedRectangle(cornerRadius: LiquidGlassTheme.chipCornerRadius, style: .continuous)
                                    .fill(LiquidGlassTheme.chipFill(isSelected: isSelected, colorScheme: colorScheme))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: LiquidGlassTheme.chipCornerRadius, style: .continuous)
                                    .strokeBorder(
                                        LiquidGlassTheme.chipStroke(isSelected: isSelected, colorScheme: colorScheme),
                                        lineWidth: 0.6
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .frame(minHeight: 38)
                    .accessibilityLabel("\(group.title) group")
                    .accessibilityValue(isSelected ? "Selected" : "Not selected")
                    .accessibilityHint(isSelected ? "Current group" : "Shows \(group.title) converters")
                    .accessibilityIdentifier("conversions.group.\(group.id)")
                }
            }
            .padding(.horizontal, 2)
        }
        .accessibilityLabel("Conversion groups")
    }

    private func dismissKeyboard() {
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
}

#Preview {
    NavigationStack {
        ConversionsTabView(viewModel: ConversionsViewModel())
            .environmentObject(FavoritesStore())
            .environmentObject(SessionStateStore())
    }
}
