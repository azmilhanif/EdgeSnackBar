// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EdgeSnackBar",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "EdgeSnackBar", targets: ["EdgeSnackBar"])
    ],
    targets: [
        .target(name: "EdgeSnackBar"),
        .testTarget(name: "EdgeSnackBarTests", dependencies: ["EdgeSnackBar"])
    ]
)
