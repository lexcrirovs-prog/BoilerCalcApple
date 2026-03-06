import Foundation

struct WaterBoilerModel: Identifiable {
    var id: String { "\(series)-\(power)" }
    let series: String
    let power: Int
    let isPremiumE: Bool
}
