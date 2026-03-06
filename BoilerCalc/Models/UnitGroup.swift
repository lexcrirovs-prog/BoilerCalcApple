import Foundation

struct UnitDef: Identifiable {
    let id = UUID()
    let name: String
    let toBase: (Double) -> Double
    let fromBase: (Double) -> Double
}

struct UnitGroup: Identifiable {
    let id = UUID()
    let name: String
    let units: [UnitDef]
}
