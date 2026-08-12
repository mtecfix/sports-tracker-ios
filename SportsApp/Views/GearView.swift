import SwiftUI

struct GearView: View {
    @ObservedObject var vm: SportsViewModel
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            List(vm.gear) { item in
                NavigationLink(destination: GearDetailView(gear: item, vm: vm)) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.name).font(.headline)
                            Spacer()
                            Text(item.condition.capitalized).font(.caption).padding(4)
                                .background(item.condition == "good" || item.condition == "excellent" ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                                .cornerRadius(4)
                        }
                        Text("\(item.brand) · \(item.type)").font(.subheadline).foregroundColor(.secondary)
                        Text("\(item.sessionCount) sessions").font(.caption).foregroundColor(.secondary)
                    }.padding(.vertical, 2)
                }
            }
            .navigationTitle("Gear")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button { showAdd = true } label: { Image(systemName: "plus") } } }
            .sheet(isPresented: $showAdd) { AddGearView(vm: vm) }
        }
    }
}
