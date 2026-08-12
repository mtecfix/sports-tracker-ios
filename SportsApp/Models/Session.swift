import Foundation
struct SportSession: Codable, Identifiable {
    let id: String
    let userId: String
    var sport: String
    var location: String
    var duration: Int
    var waveHeight: Double?
    var windSpeed: Double?
    var conditions: String?
    var rating: Int
    var notes: String
    var gearUsed: [String]
    var date: String
    let createdAt: String
    enum CodingKeys: String, CodingKey {
        case id = "ItemId", userId = "UserId"
        case sport, location, duration, waveHeight, windSpeed, conditions, rating, notes, gearUsed, date, createdAt
    }
}
struct CreateSessionRequest: Codable {
    let sport: String; let location: String; let duration: Int; let rating: Int
    let notes: String; let waveHeight: Double?; let windSpeed: Double?
    let conditions: String?; let gearUsed: [String]; let date: String?
}
