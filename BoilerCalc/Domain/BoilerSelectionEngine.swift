import Foundation

struct SelectedSteamBoiler: Identifiable {
    var id: String { "\(model.id)-\(count)" }
    let model: BoilerModel
    let count: Int
    let loadPercent: Double
}

struct SelectedWaterBoiler: Identifiable {
    var id: String { "\(model.id)-\(count)" }
    let model: WaterBoilerModel
    let count: Int
}

struct BoilerSelectionEngine {

    /// Cascade selection of steam boilers.
    /// Excludes the S-15000 model from automatic selection.
    static func selectSteamBoilers(requiredKgH: Double) -> [SelectedSteamBoiler] {
        if requiredKgH <= 0 { return [] }

        let catalogue = BoilerCatalogue.steamBoilers.filter { $0.id != "s15000" }
        if catalogue.isEmpty { return [] }

        var result: [SelectedSteamBoiler] = []
        var remaining = requiredKgH

        while remaining > 0 {
            // Find the smallest boiler that can cover the remaining capacity
            if let suitable = catalogue.first(where: { Double($0.maxSteam) >= remaining }) {
                let load = remaining / Double(suitable.maxSteam)
                result.append(SelectedSteamBoiler(model: suitable, count: 1, loadPercent: load * 100.0))
                remaining = 0.0
            } else {
                // Use the largest available boiler
                let largest = catalogue.last!
                let count = Int(remaining / Double(largest.maxSteam))
                if count > 0 {
                    result.append(SelectedSteamBoiler(model: largest, count: count, loadPercent: 100.0))
                    remaining -= Double(count) * Double(largest.maxSteam)
                } else {
                    result.append(SelectedSteamBoiler(model: largest, count: 1, loadPercent: (remaining / Double(largest.maxSteam)) * 100.0))
                    remaining = 0.0
                }
            }
        }

        return result
    }

    /// Smart selection of water boilers with N+1 redundancy.
    static func selectWaterBoilers(powerKW: Double) -> [SelectedWaterBoiler] {
        if powerKW <= 0 { return [] }
        let catalogue = BoilerCatalogue.waterBoilers

        // Case 1: Small load
        if powerKW < 250 {
            return [SelectedWaterBoiler(model: catalogue.first!, count: 1)]
        }

        // Case 3: Very large load
        if powerKW > 20000 {
            let largest = catalogue.last!
            let count = Int(ceil(powerKW / Double(largest.power)))
            return [SelectedWaterBoiler(model: largest, count: count)]
        }

        // Case 2: Standard selection with 50% redundancy
        let half = powerKW / 2.0
        let lowerIdx = catalogue.lastIndex(where: { Double($0.power) <= half })
        let upperIdx = catalogue.firstIndex(where: { Double($0.power) >= half })

        guard let lower = lowerIdx, let upper = upperIdx else {
            let suitable = catalogue.first(where: { Double($0.power) >= powerKW }) ?? catalogue.last!
            return [SelectedWaterBoiler(model: suitable, count: 2)]
        }

        let lowerModel = catalogue[lower]
        let upperModel = catalogue[upper]

        if Double(lowerModel.power + upperModel.power) >= powerKW {
            return [
                SelectedWaterBoiler(model: lowerModel, count: 1),
                SelectedWaterBoiler(model: upperModel, count: 1)
            ]
        } else {
            return [SelectedWaterBoiler(model: upperModel, count: 2)]
        }
    }
}
