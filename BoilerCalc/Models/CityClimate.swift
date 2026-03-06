import Foundation

struct CityClimate: Identifiable {
    var id: String { name }
    let name: String
    let tDesign: Double
    let tHeating: Double
    let heatingDays: Int
}
