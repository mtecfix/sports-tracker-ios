import SwiftUI

@main struct SportsApp: App {
    @StateObject private var notif = NotificationManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { Task { await notif.requestPermission() } }
        }
    }
}
