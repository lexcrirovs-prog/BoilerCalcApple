import SwiftUI

@main
struct BoilerCalcApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environment(\.themeColors, themeManager.colors)
        }
    }
}
