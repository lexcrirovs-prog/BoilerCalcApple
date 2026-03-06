import SwiftUI

enum ThemeMode: String, CaseIterable {
    case dark = "DARK"
    case light = "LIGHT"
    case latte = "LATTE"

    var displayName: String {
        switch self {
        case .dark: return "Тёмная"
        case .light: return "Светлая"
        case .latte: return "Латте"
        }
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("theme_mode") private var storedTheme: String = ThemeMode.dark.rawValue

    @Published var currentTheme: ThemeMode = .dark

    var colors: ThemeColors {
        switch currentTheme {
        case .dark: return .dark
        case .light: return .light
        case .latte: return .latte
        }
    }

    init() {
        currentTheme = ThemeMode(rawValue: storedTheme) ?? .dark
    }

    func setTheme(_ theme: ThemeMode) {
        currentTheme = theme
        storedTheme = theme.rawValue
    }
}

// MARK: - Environment Key

private struct ThemeColorsKey: EnvironmentKey {
    static let defaultValue: ThemeColors = .dark
}

extension EnvironmentValues {
    var themeColors: ThemeColors {
        get { self[ThemeColorsKey.self] }
        set { self[ThemeColorsKey.self] = newValue }
    }
}
