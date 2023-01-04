// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DangerSwiftCoverage",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DangerSwiftCoverage",
            targets: ["DangerSwiftCoverage"]
        ),
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.0.0"),
        // Dev dependencies
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"), // dev
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"), // dev
        .package(url: "https://github.com/f-meloni/Rocket", from: "1.0.0"), // dev
        .package(url: "https://github.com/orta/Komondor", from: "1.0.0"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-xcodesummary", from: "1.0.0"), // dev
    ],
    targets: [
        .target(
            name: "DangerDependencies",
            dependencies: [
                .product(name: "Danger", package: "swift"),
                "DangerSwiftCoverage",
                .product(name: "DangerXCodeSummary", package: "danger-swift-xcodesummary")
            ]
        ), // dev
        .target(
            name: "DangerSwiftCoverage",
            dependencies: [
                .product(name: "Danger", package: "swift")
            ]
        ),
        .testTarget(
            name: "DangerSwiftCoverageTests",
            dependencies: [
                "DangerSwiftCoverage",
                .product(name: "DangerFixtures", package: "swift")
            ]
        ),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-commit": [
                "swift test --generate-linuxmain",
                "swift run swiftformat .",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
        "rocket": [
            "after": [
                "push",
            ],
        ],
    ]).write()
#endif
