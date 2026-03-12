import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @FocusState private var isInputFocused: Bool
    @State private var isShowingUnitSheet = false

    private var isFavorite: Bool {
        favoritesStore.isFavorite(pairID: viewModel.selectedPair.id)
    }

    private var pairAccessibilityName: String {
        viewModel.selectedPair.title.replacingOccurrences(of: "<->", with: "and")
    }

    private var favoriteAccessibilityLabel: String {
        let action = isFavorite ? "Remove" : "Add"
        let destination = isFavorite ? "from favorites" : "to favorites"
        return "\(action) \(pairAccessibilityName) \(destination)"
    }

    private var swapAccessibilityLabel: String {
        "Swap \(viewModel.inputUnit) and \(viewModel.outputUnit)"
    }

    private var outputAccessibilityLabel: String {
        guard viewModel.outputText != "--" else {
            return "No converted value available. Enter \(viewModel.inputUnit) to convert to \(viewModel.outputUnit)"
        }
        return "Converted result \(viewModel.outputText) \(viewModel.outputUnit), from \(viewModel.inputUnit)"
    }

    private var outputDisplayText: String {
        viewModel.outputText == "--" ? "—" : viewModel.outputText
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                converterCard
            }
            .frame(maxWidth: 600)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Conversions")
        .background {
            LiquidGlassTheme.gentleCanvasGradient(for: colorScheme)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowingUnitSheet) {
            UnitPickerSheet(
                viewModel: viewModel,
                isPresented: $isShowingUnitSheet
            )
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

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Easy conversion")
                .font(.system(.title2, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            Text("Type once, see the answer instantly.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var converterCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.selectedPair.title)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text("\(viewModel.inputUnit) to \(viewModel.outputUnit)")
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }

                Spacer(minLength: 8)

                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isFavorite ? LiquidGlassTheme.favoriteTint : .secondary.opacity(0.8))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(colorScheme == .dark ? 0.12 : 0.55))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(favoriteAccessibilityLabel)
                .accessibilityIdentifier("converter.favorite.\(viewModel.selectedPair.id)")
            }

            HStack(spacing: 10) {
                unitButton(title: "From", value: viewModel.inputUnit)

                Button(action: swapUnits) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(LiquidGlassTheme.tint)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(colorScheme == .dark ? 0.14 : 0.72))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(swapAccessibilityLabel)
                .accessibilityIdentifier("converter.swap.\(viewModel.selectedPair.id)")

                unitButton(title: "To", value: viewModel.outputUnit)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    TextField("Enter value", text: $viewModel.inputText)
                        .font(.system(.title2, design: .rounded).weight(.medium).monospacedDigit())
                        .keyboardType(.numbersAndPunctuation)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($isInputFocused)
                        .accessibilityLabel("Input value in \(viewModel.inputUnit)")
                        .accessibilityIdentifier("converter.input.\(viewModel.selectedPair.id)")

                    Text(viewModel.inputUnit)
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("→")
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(LiquidGlassTheme.tint.opacity(0.9))

                    Text(outputDisplayText)
                        .font(.system(.title, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .accessibilityIdentifier("converter.output.\(viewModel.selectedPair.id)")

                    Text(viewModel.outputUnit)
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(outputAccessibilityLabel)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(colorScheme == .dark ? 0.09 : 0.60))
            )
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlassCardStyle()
        .accessibilityIdentifier("converter.card.\(viewModel.selectedPair.id)")
    }

    private func unitButton(title: String, value: String) -> some View {
        Button {
            isShowingUnitSheet = true
        } label: {
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(.caption2, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 42)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(colorScheme == .dark ? 0.10 : 0.55))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) unit \(value). Opens unit picker")
    }

    private func toggleFavorite() {
        favoritesStore.toggle(pairID: viewModel.selectedPair.id)
    }

    private func swapUnits() {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.swapUnits()
        }
    }

    private func dismissKeyboard() {
        isInputFocused = false
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
}

private struct UnitPickerSheet: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
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
            .navigationTitle("Choose Units")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Search units")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func pairRows(_ pairs: [ConversionPair]) -> some View {
        ForEach(pairs) { pair in
            Button {
                viewModel.selectPair(pair)
                viewModel.searchText = ""
                isPresented = false
            } label: {
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pair.title)
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)

                        Text("\(pair.unitA) ↔ \(pair.unitB)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 8)

                    if viewModel.selectedPairID == pair.id {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(LiquidGlassTheme.tint)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Choose \(pair.title)")
            .accessibilityIdentifier("units.row.\(pair.id)")
        }
    }
}

#Preview {
    NavigationStack {
        ConversionsTabView(viewModel: ConversionsViewModel())
            .environmentObject(FavoritesStore())
            .environmentObject(SessionStateStore())
    }
}
