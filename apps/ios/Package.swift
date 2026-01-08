// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Apply",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [
        .package(
            url: "https://github.com/ouwargui/BetterAuthSwift.git",
            .upToNextMajor(from: "2.0.0")  // always use a tag version instead of main, since main is not stable
        )
    ],
    targets: [
        .target(
            name: "Apply",
            dependencies: [
                .product(name: "BetterAuth", package: "BetterAuthSwift"),
                .product(name: "BetterAuthEmailOTP", package: "BetterAuthSwift"),
            ]
        )
    ]
)
