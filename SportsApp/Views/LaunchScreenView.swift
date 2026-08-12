import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.52, blue: 0.82),
                         Color(red: 0.02, green: 0.32, blue: 0.62)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 130, height: 130)
                    Image(systemName: "figure.surfing")
                        .font(.system(size: 64, weight: .semibold))
                        .foregroundColor(.white)
                }

                VStack(spacing: 6) {
                    Text("Sports Tracker")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Log sessions. Track your gear.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.80))
                }
            }
        }
    }
}
