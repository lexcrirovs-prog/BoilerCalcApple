import Foundation

struct CyrillicNormalization {
    static func normalize(_ text: String) -> String {
        return text.lowercased()
            .replacingOccurrences(of: "\u{0451}", with: "\u{0435}")  // ё → е
            .replacingOccurrences(of: "\u{0401}", with: "\u{0415}")  // Ё → Е
            .trimmingCharacters(in: .whitespaces)
    }

    static func matches(query: String, target: String) -> Bool {
        if query.trimmingCharacters(in: .whitespaces).isEmpty { return true }
        return normalize(target).contains(normalize(query))
    }
}
