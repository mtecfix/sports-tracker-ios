import SwiftUI
struct ContentView: View {
    @StateObject private var vm = SportsViewModel()
    var body: some View {
        TabView {
            SessionsView(vm: vm).tabItem { Label("Sessions", systemImage: "figure.surfing") }
            GearView(vm: vm).tabItem { Label("Gear", systemImage: "bag.fill") }
            StatsView(vm: vm).tabItem { Label("Stats", systemImage: "chart.bar.fill") }
        }
        .task { await vm.load() }
    }
}
