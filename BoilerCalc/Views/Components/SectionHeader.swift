import SwiftUI

struct SectionHeader: View {
    let title: String
    @Environment(\.themeColors) var colors

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(colors.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
            .padding(.bottom, 4)
    }
}
