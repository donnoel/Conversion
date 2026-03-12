import SwiftUI

struct ConverterCardView: View {
    let pair: ConversionPair

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
        "Swap conversion direction for \(pairAccessibilityName)"
    }

    private var outputAccessibilityLabel: String {
        guard viewModel.outputText != "--" else {
            return "No converted value available. Enter \(viewModel.inputUnit) to convert to \(viewModel.outputUnit)"
        }
        return "Result \(viewModel.outputText) \(viewModel.outputUnit), converted from \(viewModel.inputUnit)"
    }

    private var hasOutputValue: Bool {
        viewModel.outputText != "--"
    }

    private var outputDisplayText: String {
        hasOutputValue ? viewModel.outputText : "Enter value"
    }

    private var directionText: String {
        "\(viewModel.inputUnit) → \(viewModel.outputUnit)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 1.5) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(pair.title)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(directionText)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .accessibilityLabel("Converting \(viewModel.inputUnit) to \(viewModel.outputUnit)")
                }

                Spacer(minLength: 8)

                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(isFavorite ? Color.yellow.opacity(0.74) : .secondary.opacity(0.8))
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(Color.white.opacity(0.05)))
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(favoriteAccessibilityLabel)
                .accessibilityIdentifier("converter.favorite.\(pair.id)")
            }
            .frame(minHeight: 30)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("Input")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 38, alignment: .leading)

                TextField("Value", text: $viewModel.inputText)
                    .font(.system(.body, design: .rounded).weight(.medium).monospacedDigit())
                    .textFieldStyle(.plain)
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .layoutPriority(1)
                    .accessibilityLabel("Input value in \(viewModel.inputUnit)")
                    .accessibilityIdentifier("converter.input.\(pair.id)")

                Text(viewModel.inputUnit)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(minHeight: 18)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("Output")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(hasOutputValue ? LiquidGlassTheme.tint : .secondary)
                    .frame(width: 38, alignment: .leading)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(outputDisplayText)
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(hasOutputValue ? LiquidGlassTheme.tint : .secondary)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .accessibilityIdentifier("converter.output.\(pair.id)")

                    Text(viewModel.outputUnit)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(hasOutputValue ? .secondary : .tertiary)
                        .lineLimit(1)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(outputAccessibilityLabel)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: swapUnits) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(hasOutputValue ? LiquidGlassTheme.tint : .secondary)
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(Color.white.opacity(0.05)))
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(swapAccessibilityLabel)
                .accessibilityIdentifier("converter.swap.\(pair.id)")
            }
            .frame(minHeight: 20)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .frame(minHeight: 72)
        .liquidGlassCardStyle()
        .accessibilityIdentifier("converter.card.\(pair.id)")
        .onAppear {
            viewModel.connectSessionStateStore(sessionStateStore)
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
