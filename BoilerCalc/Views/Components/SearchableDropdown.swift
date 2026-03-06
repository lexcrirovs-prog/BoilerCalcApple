import SwiftUI

struct SearchableDropdown: View {
    @Binding var query: String
    let items: [CityClimate]
    let filteredItems: [CityClimate]
    let isExpanded: Bool
    let onQueryChange: (String) -> Void
    let onSelect: (CityClimate) -> Void
    let onDismiss: () -> Void

    @Environment(\.themeColors) var colors

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Поиск города...", text: Binding(
                get: { query },
                set: { onQueryChange($0) }
            ))
            .textFieldStyle(.roundedBorder)

            if isExpanded && !filteredItems.isEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(filteredItems.prefix(10)) { city in
                            Button(action: { onSelect(city) }) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(city.name)
                                        .foregroundColor(colors.onSurface)
                                    Text("t\u{2099}\u{2080} = \(Int(city.tDesign))\u{00B0}C, \(city.heatingDays) дней")
                                        .font(.caption)
                                        .foregroundColor(colors.onSurfaceVariant)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)

                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 200)
                .background(colors.surface)
                .cornerRadius(8)
                .shadow(radius: 2)
            }
        }
    }
}
