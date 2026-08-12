import Foundation
enum APIError: Error { case invalidURL, requestFailed(Int, String), decodingFailed(String) }
class APIService {
    static let shared = APIService()
    private let base = Config.apiEndpoint
    private var token: String? = nil
    func setToken(_ t: String) { token = t }
    private func req<T: Decodable>(_ path: String, method: String = "GET", body: Encodable? = nil) async throws -> T {
        guard let url = URL(string: "\(base)\(path)") else { throw APIError.invalidURL }
        var r = URLRequest(url: url)
        r.httpMethod = method
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let t = token { r.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization") }
        if let b = body { r.httpBody = try JSONEncoder().encode(b) }
        let (data, resp) = try await URLSession.shared.data(for: r)
        let code = (resp as! HTTPURLResponse).statusCode
        guard (200...299).contains(code) else { throw APIError.requestFailed(code, String(data: data, encoding: .utf8) ?? "") }
        do { return try JSONDecoder().decode(T.self, from: data) }
        catch { throw APIError.decodingFailed(error.localizedDescription) }
    }
    func getSessions() async throws -> [SportSession] { struct R: Decodable { let sessions: [SportSession] }; return try await (req("/sessions") as R).sessions }
    func logSession(_ s: CreateSessionRequest) async throws -> SportSession { struct R: Decodable { let session: SportSession }; return try await (req("/sessions", method: "POST", body: s) as R).session }
    func getGear() async throws -> [GearItem] { struct R: Decodable { let gear: [GearItem] }; return try await (req("/gear") as R).gear }
    func addGear(_ g: CreateGearRequest) async throws -> GearItem { struct R: Decodable { let gear: GearItem }; return try await (req("/gear", method: "POST", body: g) as R).gear }
}
