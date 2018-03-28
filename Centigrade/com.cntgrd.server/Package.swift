// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "com.cntgrd.server",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMinor(from: "1.7.1")),
        .package(url: "https://github.com/IBM-Swift/Configuration.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/IBM-Swift/Health.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery-PostgreSQL.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-protobuf.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/cntgrd/data.git", .upToNextMinor(from: "0.0.0")),
    ],
    targets: [
        .target(
            name: "com.cntgrd.server",
            dependencies: [ .target(name: "Application"), "Kitura", "HeliumLogger" ]),
        .target(
            name: "Application",
            dependencies: [ "Kitura",
                            "Configuration",
                            "Health",
                            "SwiftKuery",
                            "SwiftKueryPostgreSQL",
                            "SwiftProtobuf",
                            "CentigradeData" ],
            path: "Sources/Application"),
        .testTarget(
            name: "ApplicationTests",
            dependencies: [ .target(name: "Application"), "Kitura", "HeliumLogger" ])
    ]
)
