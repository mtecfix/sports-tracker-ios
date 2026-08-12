import Foundation
@MainActor class SportsViewModel: ObservableObject {
    @Published var sessions: [SportSession] = []
    @Published var gear: [GearItem] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    var totalSessions: Int { sessions.count }
    var avgRating: Double { sessions.isEmpty ? 0 : Double(sessions.reduce(0) { $0 + $1.rating }) / Double(sessions.count) }
    func load() async {
        isLoading = true; error = nil
        async let s = APIService.shared.getSessions()
        async let g = APIService.shared.getGear()
        do { (sessions, gear) = try await (s, g) }
        catch { self.error = error.localizedDescription }
        isLoading = false
    }
    func logSession(sport: String, location: String, duration: Int, rating: Int, notes: String, conditions: String?) async {
        let r = CreateSessionRequest(sport: sport, location: location, duration: duration, rating: rating, notes: notes, waveHeight: nil, windSpeed: nil, conditions: conditions, gearUsed: [], date: nil)
        do { let s = try await APIService.shared.logSession(r); sessions.insert(s, at: 0) }
        catch { self.error = error.localizedDescription }
    }
    func addGear(name: String, type: String, brand: String) async {
        let r = CreateGearRequest(name: name, type: type, brand: brand, condition: "good", notes: nil)
        do { let g = try await APIService.shared.addGear(r); gear.insert(g, at: 0) }
        catch { self.error = error.localizedDescription }
    }
}
