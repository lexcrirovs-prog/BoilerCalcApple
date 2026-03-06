import SwiftUI

struct UnitToggleChip: View {
    let unitText: String
    let onClick: () -> Void

    @Environment(\.themeColors) var colors

    var body: some View {
        Button(action: onClick) {
            Text(unitText)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(colors.secondaryContainer)
                .foregroundColor(colors.onSecondaryContainer)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
