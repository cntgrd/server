// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "com.cntgrd.server",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMinor(from: "3.0.0-rc.2")),
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", .upToNextMinor(from: "1.0.0-rc.2")),
        .package(url: "https://github.com/apple/swift-protobuf.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/cntgrd/data.git", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc.3"),
        .package(url: "https://github.com/vapor/crypto.git", .upToNextMinor(from: "3.0.0")),
    ],
    targets: [
        .target(name: "App", dependencies: [ "Vapor",
                                             "Fluent",
                                             "FluentPostgreSQL",
                                             "SwiftProtobuf",
                                             "CentigradeData",
                                             "Authentication",
                                             "Crypto"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

