import SwiftUI
struct StatsView: View {
    @ObservedObject var vm: SportsViewModel
    var breakdown: [(String, Int)] {
        var c: [String: Int] = []; vm.sessions.forEach { c[$0.sport, default: 0] += 1 }
        return c.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
    }
    var body: some View {
        NavigationStack {
            List {
                Section("Overview") {
                    LabeledContent("Total Sessions", value: "\(vm.totalSessions)")
                    LabeledContent("Avg Rating", value: String(format: "%.1f", vm.avgRating) + " ⭐")
                    LabeledContent("Gear Items", value: "\(vm.gear.count)")
                }
                Section("By Sport") {
                    ForEach(breakdown, id: \.0) { item in HStack { Text(item.0.capitalized); Spacer(); Text("\(item.1) sessions").foregroundColor(.secondary) } }
                }
            }
            .navigationTitle("Stats").refreshable { await vm.load() }
        }
    }
}
