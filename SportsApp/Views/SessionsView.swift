import SwiftUI

struct SessionsView: View {
    @ObservedObject var vm: SportsViewModel
    @State private var showLog = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading { ProgressView("Loading...") }
                else if vm.sessions.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "figure.surfing").font(.system(size: 48)).foregroundColor(.secondary)
                        Text("No sessions logged").font(.headline)
                        Text("Tap + to log your first session").font(.caption).foregroundColor(.secondary)
                    }
                } else {
                    List(vm.sessions) { session in
                        NavigationLink(destination: SessionDetailView(session: session, vm: vm)) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(session.sport.capitalized).font(.headline)
                                    Spacer()
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { i in
                                            Image(systemName: i < session.rating ? "star.fill" : "star")
                                                .font(.caption2).foregroundColor(.yellow)
                                        }
                                    }
                                }
                                HStack {
                                    Image(systemName: "mappin").foregroundColor(.red)
                                    Text(session.location).font(.subheadline)
                                    Spacer()
                                    Text("\(session.duration) min").font(.caption).foregroundColor(.secondary)
                                }
                                if let c = session.conditions { Text(c).font(.caption).foregroundColor(.secondary) }
                                Text(session.date).font(.caption2).foregroundColor(.secondary)
                            }.padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Sessions")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button { showLog = true } label: { Image(systemName: "plus") } } }
            .sheet(isPresented: $showLog) { LogSessionView(vm: vm) }
        }
    }
}
