import Foundation

struct Formatting {
    private static let russianLocale = Locale(identifier: "ru_RU")

    static func formatMoney(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = russianLocale
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        let formatted = formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
        return "\(formatted) руб"
    }

    static func formatNumber(_ value: Double, decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = russianLocale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.\(decimals)f", value)
    }

    static func parseMoney(_ text: String) -> Double {
        let cleaned = text
            .replacingOccurrences(of: "[^0-9,.]", with: "", options: .regularExpression)
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleaned) ?? 0.0
    }

    /// Format number and trim trailing zeros after decimal
    static func formatTrimmed(_ value: Double, decimals: Int = 2) -> String {
        let raw = formatNumber(value, decimals: decimals)
        if !raw.contains(",") { return raw }
        var result = raw
        while result.hasSuffix("0") { result = String(result.dropLast()) }
        if result.hasSuffix(",") { result = String(result.dropLast()) }
        return result
    }
}
