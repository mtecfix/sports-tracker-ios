import SwiftUI
struct LogSessionView: View {
    @ObservedObject var vm: SportsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var sport = "surfing"
    @State private var location = ""
    @State private var duration = ""
    @State private var rating = 3
    @State private var notes = ""
    @State private var conditions = ""
    let sports = ["surfing","climbing","golf","windsurfing","cycling","snowboarding"]
    var body: some View {
        NavigationStack {
            Form {
                Section("Session") {
                    Picker("Sport", selection: $sport) { ForEach(sports, id: \.self) { Text($0.capitalized) } }
                    TextField("Location", text: $location)
                    HStack { TextField("Duration", text: $duration).keyboardType(.numberPad); Text("min") }
                }
                Section("Conditions") { TextField("e.g. 3ft waves, offshore wind", text: $conditions) }
                Section("Rating") {
                    HStack {
                        ForEach(1..<6) { i in
                            Button { rating = i } label: { Image(systemName: i <= rating ? "star.fill" : "star").foregroundColor(.yellow).font(.title2) }
                        }
                    }
                }
                Section("Notes") { TextEditor(text: $notes).frame(height: 80) }
            }
            .navigationTitle("Log Session").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Log") { Task { await vm.logSession(sport: sport, location: location, duration: Int(duration) ?? 0, rating: rating, notes: notes, conditions: conditions.isEmpty ? nil : conditions); dismiss() } }
                    .disabled(location.isEmpty)
                }
            }
        }
    }
}
