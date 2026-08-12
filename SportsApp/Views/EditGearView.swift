import SwiftUI

struct EditGearView: View {
    @ObservedObject var vm: SportsViewModel
    let gear: GearItem
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var type: String
    @State private var brand: String
    @State private var condition: String
    @State private var notes: String
    @State private var loading = false; @State private var error: String? = nil

    let conditions = ["excellent","good","fair","poor"]

    init(vm: SportsViewModel, gear: GearItem) {
        self.vm = vm; self.gear = gear
        _name      = State(initialValue: gear.name)
        _type      = State(initialValue: gear.type)
        _brand     = State(initialValue: gear.brand)
        _condition = State(initialValue: gear.condition)
        _notes     = State(initialValue: gear.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Gear Name", text: $name)
                    TextField("Type (e.g. surfboard)", text: $type)
                    TextField("Brand", text: $brand)
                }
                Section("Condition") {
                    Picker("Condition", selection: $condition) {
                        ForEach(conditions, id: \.self) { Text($0.capitalized) }
                    }.pickerStyle(.segmented)
                }
                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical).lineLimit(2...4)
                }
                if let e = error { Section { Text(e).foregroundColor(.red).font(.caption) } }
            }
            .navigationTitle("Edit Gear").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.disabled(name.isEmpty || brand.isEmpty || loading)
                }
            }
        }
    }

    func save() {
        loading = true; error = nil
        Task {
            do {
                try await vm.updateGear(gearId: gear.id, name: name, type: type, brand: brand, condition: condition, notes: notes)
                dismiss()
            } catch { self.error = error.localizedDescription }
            loading = false
        }
    }
}
