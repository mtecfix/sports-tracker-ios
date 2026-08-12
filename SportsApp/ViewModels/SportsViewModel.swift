import Foundation

@MainActor class SportsViewModel: ObservableObject {
    @Published var sessions: [SportSession] = []
    @Published var gear: [GearItem] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    @Published var isOffline = false

    var totalSessions: Int { sessions.count }
    var avgRating: Double { sessions.isEmpty ? 0 : Double(sessions.reduce(0) { $0 + $1.rating }) / Double(sessions.count) }

    func load() async {
        if let cs = LocalCache.shared.load(SportSession.self, key: "cached_sessions") { sessions = cs }
        if let cg = LocalCache.shared.load(GearItem.self, key: "cached_gear") { gear = cg }
        isLoading = true; error = nil
        async let s = APIService.shared.getSessions()
        async let g = APIService.shared.getGear()
        do {
            (sessions, gear) = try await (s, g)
            LocalCache.shared.save(sessions, key: "cached_sessions")
            LocalCache.shared.save(gear, key: "cached_gear")
            isOffline = false
        } catch { if sessions.isEmpty { self.error = error.localizedDescription }; isOffline = true }
        isLoading = false
    }

    func logSession(sport: String, location: String, duration: Int, rating: Int, notes: String, conditions: String?, waveHeight: Double? = nil, windSpeed: Double? = nil) async {
        let r = CreateSessionRequest(sport: sport, location: location, duration: duration, rating: rating, notes: notes, waveHeight: waveHeight, windSpeed: windSpeed, conditions: conditions, gearUsed: [], date: nil)
        do { let s = try await APIService.shared.logSession(r); sessions.insert(s, at: 0); LocalCache.shared.save(sessions, key: "cached_sessions") }
        catch { self.error = error.localizedDescription }
    }

    func deleteSession(sessionId: String) async {
        do { try await APIService.shared.deleteSession(sessionId: sessionId); sessions.removeAll { $0.id == sessionId }; LocalCache.shared.save(sessions, key: "cached_sessions") }
        catch { self.error = error.localizedDescription }
    }

    func addGear(name: String, type: String, brand: String) async {
        let r = CreateGearRequest(name: name, type: type, brand: brand, condition: "good", notes: nil)
        do { let g = try await APIService.shared.addGear(r); gear.insert(g, at: 0); LocalCache.shared.save(gear, key: "cached_gear") }
        catch { self.error = error.localizedDescription }
    }

    func updateGear(gearId: String, name: String, type: String, brand: String, condition: String, notes: String) async throws {
        try await APIService.shared.updateGear(gearId: gearId, name: name, type: type, brand: brand, condition: condition, notes: notes)
        if let idx = gear.firstIndex(where: { $0.id == gearId }) {
            gear[idx].name = name; gear[idx].type = type; gear[idx].brand = brand
            gear[idx].condition = condition; gear[idx].notes = notes
            LocalCache.shared.save(gear, key: "cached_gear")
        }
    }

    func deleteGear(gearId: String) async {
        do { try await APIService.shared.deleteGear(gearId: gearId); gear.removeAll { $0.id == gearId }; LocalCache.shared.save(gear, key: "cached_gear") }
        catch { self.error = error.localizedDescription }
    }
}
