import SwiftUI

// MARK: - Theme Color Palettes

struct ThemeColors {
    let primary: Color
    let onPrimary: Color
    let primaryContainer: Color
    let onPrimaryContainer: Color
    let secondary: Color
    let onSecondary: Color
    let secondaryContainer: Color
    let onSecondaryContainer: Color
    let tertiary: Color
    let onTertiary: Color
    let tertiaryContainer: Color
    let onTertiaryContainer: Color
    let error: Color
    let onError: Color
    let background: Color
    let onBackground: Color
    let surface: Color
    let onSurface: Color
    let surfaceVariant: Color
    let onSurfaceVariant: Color
    let outline: Color
}

extension ThemeColors {
    // ═══ Dark Theme ═══
    static let dark = ThemeColors(
        primary: Color(hex: 0xFF1E88E5),
        onPrimary: Color.white,
        primaryContainer: Color(hex: 0xFF1565C0),
        onPrimaryContainer: Color(hex: 0xFFBBDEFB),
        secondary: Color(hex: 0xFFA5D6A7),
        onSecondary: Color(hex: 0xFF1B5E20),
        secondaryContainer: Color(hex: 0xFF2E7D32),
        onSecondaryContainer: Color(hex: 0xFFC8E6C9),
        tertiary: Color(hex: 0xFFFFC107),
        onTertiary: Color(hex: 0xFF3E2723),
        tertiaryContainer: Color(hex: 0xFFF57F17),
        onTertiaryContainer: Color(hex: 0xFFFFF8E1),
        error: Color(hex: 0xFFFF5252),
        onError: Color.white,
        background: Color(hex: 0xFF161B22),
        onBackground: Color(hex: 0xFFD1D5DB),
        surface: Color(hex: 0xFF1F2630),
        onSurface: Color(hex: 0xFFD1D5DB),
        surfaceVariant: Color(hex: 0xFF2E3A4A),
        onSurfaceVariant: Color(hex: 0xFF7B9BB5),
        outline: Color(hex: 0xFF2E3A4A)
    )

    // ═══ Light Theme ═══
    static let light = ThemeColors(
        primary: Color(hex: 0xFF1565C0),
        onPrimary: Color.white,
        primaryContainer: Color(hex: 0xFFBBDEFB),
        onPrimaryContainer: Color(hex: 0xFF0D47A1),
        secondary: Color(hex: 0xFF4CAF50),
        onSecondary: Color.white,
        secondaryContainer: Color(hex: 0xFFC8E6C9),
        onSecondaryContainer: Color(hex: 0xFF1B5E20),
        tertiary: Color(hex: 0xFFFF9800),
        onTertiary: Color.white,
        tertiaryContainer: Color(hex: 0xFFFFE0B2),
        onTertiaryContainer: Color(hex: 0xFFE65100),
        error: Color(hex: 0xFFD32F2F),
        onError: Color.white,
        background: Color(hex: 0xFFFAFAFA),
        onBackground: Color(hex: 0xFF1A1A2E),
        surface: Color.white,
        onSurface: Color(hex: 0xFF1A1A2E),
        surfaceVariant: Color(hex: 0xFFF5F5F5),
        onSurfaceVariant: Color(hex: 0xFF49454F),
        outline: Color(hex: 0xFFCAC4D0)
    )

    // ═══ Latte Theme ═══
    static let latte = ThemeColors(
        primary: Color(hex: 0xFF8B6914),
        onPrimary: Color.white,
        primaryContainer: Color(hex: 0xFFFFDEA1),
        onPrimaryContainer: Color(hex: 0xFF5D4200),
        secondary: Color(hex: 0xFF6B8E23),
        onSecondary: Color.white,
        secondaryContainer: Color(hex: 0xFFD4E6A5),
        onSecondaryContainer: Color(hex: 0xFF3B5500),
        tertiary: Color(hex: 0xFFCD853F),
        onTertiary: Color.white,
        tertiaryContainer: Color(hex: 0xFFFFDCC2),
        onTertiaryContainer: Color(hex: 0xFF6B3A00),
        error: Color(hex: 0xFFBA1A1A),
        onError: Color.white,
        background: Color(hex: 0xFFFAF6F0),
        onBackground: Color(hex: 0xFF3E2C1C),
        surface: Color(hex: 0xFFF0E8DC),
        onSurface: Color(hex: 0xFF3E2C1C),
        surfaceVariant: Color(hex: 0xFFE8DDD0),
        onSurfaceVariant: Color(hex: 0xFF6B5D4F),
        outline: Color(hex: 0xFFD4C5B0)
    )
}

// MARK: - Color hex initializer

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
