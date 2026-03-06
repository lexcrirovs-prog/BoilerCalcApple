import Foundation

struct EconomicsResult: Identifiable {
    var id: Int { year }
    let year: Int
    let revenue: Double
    let cashFlow: Double
    let cumCashFlow: Double
    let presentValue: Double
    let cumPresentValue: Double
}

struct PaybackResult {
    let pp: Double
    let dpbp: Double
    let table: [EconomicsResult]
}
