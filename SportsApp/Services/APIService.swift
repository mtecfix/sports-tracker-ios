import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL, requestFailed(Int, String), decodingFailed(String)
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let c, let m): return "Error (\(c)): \(m)"
        case .decodingFailed(let m): return "Decode error: \(m)"
        }
    }
}

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
    func deleteSession(sessionId: String) async throws {
        struct R: Decodable { let deleted: Bool }
        let enc = sessionId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? sessionId
        let _: R = try await req("/sessions/\(enc)", method: "DELETE")
    }
    func getGear() async throws -> [GearItem] { struct R: Decodable { let gear: [GearItem] }; return try await (req("/gear") as R).gear }
    func addGear(_ g: CreateGearRequest) async throws -> GearItem { struct R: Decodable { let gear: GearItem }; return try await (req("/gear", method: "POST", body: g) as R).gear }
    func updateGear(gearId: String, name: String, type: String, brand: String, condition: String, notes: String) async throws {
        struct Body: Encodable { let name: String; let type: String; let brand: String; let condition: String; let notes: String }
        struct R: Decodable { let updated: Bool }
        let enc = gearId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? gearId
        let _: R = try await req("/gear/\(enc)", method: "PUT", body: Body(name: name, type: type, brand: brand, condition: condition, notes: notes))
    }
    func deleteGear(gearId: String) async throws {
        struct R: Decodable { let deleted: Bool }
        let enc = gearId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? gearId
        let _: R = try await req("/gear/\(enc)", method: "DELETE")
    }
    func getPhotoUploadURL() async throws -> (uploadUrl: String, key: String) {
        struct R: Decodable { let uploadUrl: String; let key: String }
        let r: R = try await req("/photo-upload")
        return (r.uploadUrl, r.key)
    }
}
