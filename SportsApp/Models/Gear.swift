import Foundation
struct GearItem: Codable, Identifiable {
    let id: String
    let userId: String
    var name: String
    var type: String
    var brand: String
    var condition: String
    var sessionCount: Int
    var notes: String?
    let createdAt: String
    enum CodingKeys: String, CodingKey {
        case id = "RecordId", userId = "UserId"
        case name, type, brand, condition, sessionCount, notes, createdAt
    }
}
struct CreateGearRequest: Codable {
    let name: String; let type: String; let brand: String
    let condition: String; let notes: String?
}
