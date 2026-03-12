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
        "Swap \(pairAccessibilityName)"
    }

    private var outputAccessibilityLabel: String {
        guard viewModel.outputText != "--" else {
            return "Converted value unavailable"
        }
        return "Converted result \(viewModel.outputText) \(viewModel.outputUnit)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(pair.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("\(viewModel.inputUnit) ↔ \(viewModel.outputUnit)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                HStack(spacing: 8) {
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(isFavorite ? .yellow : .secondary)
                            .frame(width: 44, height: 44)
                            .background(.thinMaterial, in: Circle())
                            .overlay(Circle().strokeBorder(Color.white.opacity(0.18), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(favoriteAccessibilityLabel)
                    .accessibilityIdentifier("converter.favorite.\(pair.id)")

                    Button(action: swapUnits) {
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(LiquidGlassTheme.tint)
                            .frame(width: 44, height: 44)
                            .background(.thinMaterial, in: Circle())
                            .overlay(Circle().strokeBorder(Color.white.opacity(0.18), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(swapAccessibilityLabel)
                    .accessibilityIdentifier("converter.swap.\(pair.id)")
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Input")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    TextField("Value", text: $viewModel.inputText)
                        .font(.system(.title3, design: .rounded).monospacedDigit())
                        .keyboardType(.numbersAndPunctuation)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Input value in \(viewModel.inputUnit)")
                        .accessibilityIdentifier("converter.input.\(pair.id)")

                    Text(viewModel.inputUnit)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(11)
            .liquidGlassSurfaceStyle(cornerRadius: 12)

            VStack(alignment: .leading, spacing: 6) {
                Text("Output")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(viewModel.outputText)
                        .font(.system(.title2, design: .rounded).weight(.semibold))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .accessibilityIdentifier("converter.output.\(pair.id)")

                    Text(viewModel.outputUnit)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(outputAccessibilityLabel)
            }
            .padding(11)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(LiquidGlassTheme.tint.opacity(0.10))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.20), lineWidth: 1)
                    )
            )
        }
        .padding(14)
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
