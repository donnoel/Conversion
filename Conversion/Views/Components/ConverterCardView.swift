import SwiftUI

struct ConverterCardView: View {
    let pair: ConversionPair

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @EnvironmentObject private var sessionStateStore: SessionStateStore
    @StateObject private var viewModel: ConverterCardViewModel

    init(pair: ConversionPair) {
        self.pair = pair
        _viewModel = StateObject(wrappedValue: ConverterCardViewModel(pair: pair))
    }

    private var isFavorite: Bool {
        favoritesStore.isFavorite(pairID: pair.id)
    }

    private var pairAccessibilityName: String {
        pair.title.replacingOccurrences(of: "<->", with: "and")
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

    private var hasOutputValue: Bool {
        viewModel.outputText != "--"
    }

    private var outputDisplayText: String {
        hasOutputValue ? viewModel.outputText : "—"
    }

    private var outputColor: Color {
        hasOutputValue ? LiquidGlassTheme.tint : .secondary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            titleRow
            conversionBody
        }
        .padding(.horizontal, LiquidGlassTheme.cardPadding)
        .padding(.vertical, 14)
        .frame(minHeight: 128)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlassCardStyle()
        .accessibilityIdentifier("converter.card.\(pair.id)")
        .onAppear {
            viewModel.connectSessionStateStore(sessionStateStore)
        }
    }

    private var titleRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(pair.title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.86) : .primary.opacity(0.82))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text("\(viewModel.inputUnit) to \(viewModel.outputUnit)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .accessibilityLabel("Converting \(viewModel.inputUnit) to \(viewModel.outputUnit)")
            }

            Spacer(minLength: 8)

            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(isFavorite ? LiquidGlassTheme.tint.opacity(0.95) : .secondary.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(isFavorite ? LiquidGlassTheme.tint.opacity(0.14) : Color.white.opacity(0.06))
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(favoriteAccessibilityLabel)
            .accessibilityIdentifier("converter.favorite.\(pair.id)")
        }
    }

    private var conversionBody: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("From")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        TextField("Value", text: $viewModel.inputText)
                            .font(.system(.title3, design: .rounded).weight(.medium).monospacedDigit())
                            .textFieldStyle(.plain)
                            .keyboardType(.numbersAndPunctuation)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .layoutPriority(1)
                            .accessibilityLabel("Input value in \(viewModel.inputUnit)")
                            .accessibilityIdentifier("converter.input.\(pair.id)")

                        Text(viewModel.inputUnit)
                            .font(.system(.callout, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("To")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(outputColor)

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(outputDisplayText)
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .foregroundStyle(outputColor)
                            .monospacedDigit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .accessibilityIdentifier("converter.output.\(pair.id)")

                        Text(viewModel.outputUnit)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(hasOutputValue ? .secondary : .tertiary)
                            .lineLimit(1)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(outputAccessibilityLabel)
                }
            }

            Spacer(minLength: 0)

            Button(action: swapUnits) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(hasOutputValue ? LiquidGlassTheme.tint : .secondary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(colorScheme == .dark ? 0.10 : 0.24))
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(swapAccessibilityLabel)
            .accessibilityIdentifier("converter.swap.\(pair.id)")
        }
    }

    private func toggleFavorite() {
        favoritesStore.toggle(pairID: pair.id)
    }

    private func swapUnits() {
        if reduceMotion {
            viewModel.swapUnits()
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.swapUnits()
            }
        }
    }
}

#Preview {
    ConverterCardView(pair: ConversionCatalog.allPairs[0])
        .padding()
        .background(LiquidGlassTheme.canvasGradient(for: .dark).ignoresSafeArea())
        .environmentObject(FavoritesStore())
        .environmentObject(SessionStateStore())
}
