import Foundation

struct LeadFormData: Codable {
    let name: String
    let phone: String
    let region: String
    let context: String
    var model: String = ""
    var boilerType: String = ""
    var pressure: Double?
    var capacity: Double?
    var utm: [String: String] = [:]
    var timestamp: String = ""
}
