import SwiftUI

struct ContentView: View {
    @StateObject private var vm   = SportsViewModel()
    @StateObject private var auth = AuthService.shared
    var body: some View {
        if auth.isAuthenticated {
            TabView {
                SessionsView(vm: vm).tabItem { Label("Sessions", systemImage: "figure.surfing") }
                GearView(vm: vm).tabItem { Label("Gear", systemImage: "bag.fill") }
                SportsChartsView(vm: vm).tabItem { Label("Charts", systemImage: "chart.bar.fill") }
                StatsView(vm: vm).tabItem { Label("Stats", systemImage: "number.circle.fill") }
            }
            .task { await vm.load() }
        } else {
            LoginView()
        }
    }
}
