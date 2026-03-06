import Foundation

struct LeadApiService {
    static let baseURL = "https://kotelgavno.ru/"

    static func submitLead(_ data: LeadFormData) async throws {
        guard let url = URL(string: "\(baseURL)api/leads/") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(data)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
