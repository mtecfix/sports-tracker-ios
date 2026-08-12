import SwiftUI
struct AddGearView: View {
    @ObservedObject var vm: SportsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""; @State private var type = ""; @State private var brand = ""
    var body: some View {
        NavigationStack {
            Form { Section { TextField("Gear Name", text: $name); TextField("Type (e.g. surfboard)", text: $type); TextField("Brand", text: $brand) } }
            .navigationTitle("Add Gear").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { Task { await vm.addGear(name: name, type: type, brand: brand); dismiss() } }.disabled(name.isEmpty) }
            }
        }
    }
}
