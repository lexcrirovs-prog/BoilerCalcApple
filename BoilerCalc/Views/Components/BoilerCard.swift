import SwiftUI

struct SteamBoilerCard: View {
    let boiler: SelectedSteamBoiler

    @Environment(\.themeColors) var colors

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(boiler.model.name)
                    .font(.headline)
                    .foregroundColor(colors.onSurface)
                Spacer()
                Text("\(boiler.count) шт.")
                    .font(.subheadline)
                    .foregroundColor(colors.primary)
            }

            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Диапазон")
                        .font(.caption)
                        .foregroundColor(colors.onSurfaceVariant)
                    Text("\(boiler.model.minSteam)-\(boiler.model.maxSteam) кг/ч")
                        .font(.subheadline)
                }

                VStack(alignment: .leading) {
                    Text("Загрузка")
                        .font(.caption)
                        .foregroundColor(colors.onSurfaceVariant)
                    Text(Formatting.formatTrimmed(boiler.loadPercent, decimals: 1) + "%")
                        .font(.subheadline)
                }

                VStack(alignment: .leading) {
                    Text("Газ (8484)")
                        .font(.caption)
                        .foregroundColor(colors.onSurfaceVariant)
                    Text("\(boiler.model.gas8484) м\u{00B3}/ч")
                        .font(.subheadline)
                }
            }

            // Product link
            if let urls = BoilerUrls.steamUrls[boiler.model.id] {
                HStack(spacing: 8) {
                    ForEach(Array(urls.keys.sorted()), id: \.self) { pressure in
                        if let path = urls[pressure],
                           let url = URL(string: BoilerUrls.baseURL + path) {
                            Link(destination: url) {
                                Text(pressure)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(colors.primaryContainer)
                                    .foregroundColor(colors.onPrimaryContainer)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(colors.surfaceVariant)
        .cornerRadius(12)
    }
}

struct WaterBoilerCard: View {
    let boiler: SelectedWaterBoiler

    @Environment(\.themeColors) var colors

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(boiler.model.series) - \(boiler.model.power)")
                    .font(.headline)
                    .foregroundColor(colors.onSurface)
                Spacer()
                Text("\(boiler.count) шт.")
                    .font(.subheadline)
                    .foregroundColor(colors.primary)
            }

            Text("Мощность: \(boiler.model.power) кВт")
                .font(.subheadline)
                .foregroundColor(colors.onSurfaceVariant)
        }
        .padding()
        .background(colors.surfaceVariant)
        .cornerRadius(12)
    }
}
