import Foundation

struct EconBoilerModel: Identifiable {
    let id: String
    let name: String
    let maxGas: Double
    let price: Int64
    let efficiency: Double
    let economizerPrice: Int64?

    init(id: String, name: String, maxGas: Double, price: Int64, efficiency: Double, economizerPrice: Int64? = nil) {
        self.id = id
        self.name = name
        self.maxGas = maxGas
        self.price = price
        self.efficiency = efficiency
        self.economizerPrice = economizerPrice
    }
}
