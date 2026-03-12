import SwiftUI

struct ConverterCardView: View {
    let pair: ConversionPair

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @StateObject private var viewModel: ConverterCardViewModel

    init(pair: ConversionPair) {
        self.pair = pair
        _viewModel = StateObject(wrappedValue: ConverterCardViewModel(pair: pair))
    }

    private var isFavorite: Bool {
        favoritesStore.isFavorite(pairID: pair.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Text(pair.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer(minLength: 8)

                HStack(spacing: 8) {
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.headline)
                            .foregroundStyle(isFavorite ? .yellow : .secondary)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")

                    Button(action: swapUnits) {
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .font(.title3)
                            .foregroundStyle(LiquidGlassTheme.tint)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Swap units")
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Input")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    TextField("Value", text: $viewModel.inputText)
                        .font(.system(.title3, design: .rounded).monospacedDigit())
                        .keyboardType(.numbersAndPunctuation)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Input value")

                    Text(viewModel.inputUnit)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text("Output")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(viewModel.outputText)
                        .font(.system(.title2, design: .rounded).weight(.semibold))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)

                    Text(viewModel.outputUnit)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel("Output \(viewModel.outputText) \(viewModel.outputUnit)")
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(16)
        .liquidGlassCardStyle()
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
}
