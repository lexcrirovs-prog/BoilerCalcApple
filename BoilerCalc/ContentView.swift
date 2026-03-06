import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = 0
    @State private var showThemeMenu = false

    var colors: ThemeColors { themeManager.colors }

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                SteamPropertiesView()
                    .tabItem {
                        Image(systemName: "flame.fill")
                        Text("Пар")
                    }
                    .tag(0)

                UnitConverterView()
                    .tabItem {
                        Image(systemName: "arrow.left.arrow.right")
                        Text("Конвертер")
                    }
                    .tag(1)

                HeatCalculationView()
                    .tabItem {
                        Image(systemName: "thermometer.sun.fill")
                        Text("Тепло")
                    }
                    .tag(2)

                EconomicsView()
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Экономика")
                    }
                    .tag(3)
            }
            .tint(colors.primary)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Паровой калькулятор")
                        .font(.headline)
                        .foregroundColor(colors.primary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(ThemeMode.allCases, id: \.self) { mode in
                            Button(action: { themeManager.setTheme(mode) }) {
                                HStack {
                                    Text(mode.displayName)
                                    if themeManager.currentTheme == mode {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "paintpalette.fill")
                            .foregroundColor(colors.onSurface)
                    }
                }
            }
            .toolbarBackground(colors.surface, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .environment(\.themeColors, colors)
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
    }
}
