import Foundation

struct Building: Identifiable {
    var id: Int = 0
    var type: String = "Производственное"
    var width: Double = 0.0
    var length: Double = 0.0
    var height: Double = 0.0
    var volume: Double = 0.0
    var q0: Double = 0.5
    var useManualVolume: Bool = false
}
