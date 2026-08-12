// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "SportsApp", platforms: [.iOS(.v16)],
    products: [.library(name: "SportsApp", targets: ["SportsApp"])],
    targets: [.target(name: "SportsApp"), .testTarget(name: "SportsAppTests", dependencies: ["SportsApp"])]
)
