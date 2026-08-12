import SwiftUI

struct SessionDetailView: View {
    let session: SportSession
    @ObservedObject var vm: SportsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirm = false

    var body: some View {
        List {
            Section("Session") {
                LabeledContent("Sport",    value: session.sport.capitalized)
                LabeledContent("Location", value: session.location)
                LabeledContent("Duration", value: "\(session.duration) min")
                LabeledContent("Date",     value: session.date)
                HStack {
                    Text("Rating")
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < session.rating ? "star.fill" : "star")
                                .foregroundColor(.yellow).font(.caption)
                        }
                    }
                }
            }

            if session.waveHeight != nil || session.windSpeed != nil || session.conditions != nil {
                Section("Conditions") {
                    if let wh = session.waveHeight { LabeledContent("Wave Height", value: String(format: "%.1f ft", wh)) }
                    if let ws = session.windSpeed  { LabeledContent("Wind Speed",  value: String(format: "%.1f mph", ws)) }
                    if let c  = session.conditions { LabeledContent("Conditions",  value: c) }
                }
            }

            if !session.notes.isEmpty {
                Section("Notes") { Text(session.notes) }
            }

            if !session.gearUsed.isEmpty {
                Section("Gear Used") {
                    ForEach(session.gearUsed, id: \.self) { gearId in
                        let gearName = vm.gear.first(where: { $0.id == gearId })?.name ?? gearId
                        Text(gearName)
                    }
                }
            }

            Section {
                Button(role: .destructive) { showDeleteConfirm = true } label: {
                    Label("Delete Session", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Session Detail")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete this session?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task { await vm.deleteSession(sessionId: session.id); dismiss() }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
