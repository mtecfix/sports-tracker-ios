import SwiftUI

struct SportsChartsView: View {
    @ObservedObject var vm: SportsViewModel

    var ratingTrend: [(String, Double)] {
        vm.sessions.suffix(10).map { (String($0.date.suffix(5)), Double($0.rating)) }
    }

    var sessionsByMonth: [(String, Int)] {
        var monthly: [String: Int] = [:]
        vm.sessions.forEach { monthly[String($0.date.prefix(7)), default: 0] += 1 }
        return monthly.sorted { $0.key < $1.key }.suffix(6).map { ($0.key, $0.value) }
    }

    var topGear: [(GearItem, Int)] {
        vm.gear.sorted { $0.sessionCount > $1.sessionCount }.prefix(5).map { ($0, $0.sessionCount) }
    }

    var sportBreakdown: [(String, Int)] {
        var counts: [String: Int] = []; vm.sessions.forEach { counts[$0.sport, default: 0] += 1 }
        return counts.sorted { $0.value > $1.value }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Overview") {
                    HStack {
                        StatCard2(title: "Sessions", value: "\(vm.totalSessions)", color: .blue)
                        StatCard2(title: "Avg Rating", value: String(format: "%.1f⭐", vm.avgRating), color: .yellow)
                        StatCard2(title: "Gear Items", value: "\(vm.gear.count)", color: .green)
                    }
                    .listRowInsets(EdgeInsets()).padding(.vertical, 8)
                }

                Section("Sessions by Month") {
                    if sessionsByMonth.isEmpty {
                        Text("No sessions yet").foregroundColor(.secondary)
                    } else {
                        let maxVal = Double(sessionsByMonth.map { $0.1 }.max() ?? 1)
                        VStack(spacing: 8) {
                            ForEach(sessionsByMonth, id: \.0) { month, count in
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(month).font(.caption).foregroundColor(.secondary)
                                        Spacer()
                                        Text("\(count) sessions").font(.caption.bold())
                                    }
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.blue.opacity(0.7))
                                            .frame(width: geo.size.width * CGFloat(Double(count) / maxVal), height: 20)
                                    }
                                    .frame(height: 20)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Rating Trend (Last 10)") {
                    if ratingTrend.isEmpty {
                        Text("No sessions yet").foregroundColor(.secondary)
                    } else {
                        HStack(alignment: .bottom, spacing: 4) {
                            ForEach(ratingTrend, id: \.0) { date, rating in
                                VStack(spacing: 2) {
                                    Text(String(format: "%.0f", rating)).font(.system(size: 9)).foregroundColor(.secondary)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(rating >= 4 ? Color.green : rating >= 3 ? Color.orange : Color.red)
                                        .frame(width: 24, height: CGFloat(rating * 8))
                                    Text(date).font(.system(size: 8)).foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 80)
                        .padding(.vertical, 8)
                    }
                }

                Section("By Sport") {
                    ForEach(sportBreakdown, id: \.0) { sport, count in
                        HStack {
                            Text(sport.capitalized).font(.subheadline)
                            Spacer()
                            Text("\(count)").font(.subheadline.bold())
                        }
                    }
                }

                Section("Top Gear") {
                    ForEach(topGear, id: \.0.id) { gear, count in
                        HStack {
                            Text(gear.name).font(.subheadline)
                            Spacer()
                            Text("\(count) sessions").font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Performance").navigationBarTitleDisplayMode(.inline)
            .refreshable { await vm.load() }
        }
    }
}

struct StatCard2: View {
    let title: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(title).font(.caption).foregroundColor(.secondary)
            Text(value).font(.subheadline.bold()).foregroundColor(color)
        }
        .frame(maxWidth: .infinity).padding(8)
        .background(color.opacity(0.08)).cornerRadius(8).padding(.horizontal, 4)
    }
}
