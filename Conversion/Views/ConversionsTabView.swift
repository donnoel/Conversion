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
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.categories) { category in
                    let pairs = viewModel.pairs(for: category)

                    if !pairs.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.title)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.95) : .primary)
                                .padding(.horizontal, 4)

                            LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                                ForEach(pairs) { pair in
                                    ConverterCardView(pair: pair)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle("Conversions")
        .background(LiquidGlassTheme.canvasGradient(for: colorScheme).ignoresSafeArea())
    }
}

#Preview {
    NavigationStack {
        ConversionsTabView(viewModel: ConversionsViewModel())
            .environmentObject(FavoritesStore())
    }
}
