import SwiftUI

struct GearDetailView: View {
    let gear: GearItem
    @ObservedObject var vm: SportsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false
    @State private var showDeleteConfirm = false

    var sessionsWithGear: [SportSession] {
        vm.sessions.filter { $0.gearUsed.contains(gear.id) }
    }

    var body: some View {
        List {
            Section("Gear Info") {
                LabeledContent("Name",    value: gear.name)
                LabeledContent("Type",    value: gear.type)
                LabeledContent("Brand",   value: gear.brand)
                HStack {
                    Text("Condition")
                    Spacer()
                    Text(gear.condition.capitalized)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(conditionColor(gear.condition).opacity(0.15))
                        .foregroundColor(conditionColor(gear.condition))
                        .cornerRadius(6)
                }
                LabeledContent("Sessions Used", value: "\(gear.sessionCount)")
                if let pd = gear.purchaseDate { LabeledContent("Purchased", value: pd) }
            }

            if let notes = gear.notes, !notes.isEmpty {
                Section("Notes") { Text(notes) }
            }

            if !sessionsWithGear.isEmpty {
                Section("Used In") {
                    ForEach(sessionsWithGear.prefix(5)) { s in
                        HStack {
                            Text(s.sport.capitalized).font(.subheadline)
                            Spacer()
                            Text(s.date).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }

            Section {
                Button(role: .destructive) { showDeleteConfirm = true } label: {
                    Label("Delete Gear", systemImage: "trash")
                }
            }
        }
        .navigationTitle(gear.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showEdit = true } label: { Image(systemName: "pencil") }
            }
        }
        .sheet(isPresented: $showEdit) { EditGearView(vm: vm, gear: gear) }
        .confirmationDialog("Delete \(gear.name)?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task { await vm.deleteGear(gearId: gear.id); dismiss() }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    func conditionColor(_ c: String) -> Color {
        switch c {
        case "excellent", "good": return .green
        case "fair": return .orange
        case "poor": return .red
        default: return .secondary
        }
    }
}
