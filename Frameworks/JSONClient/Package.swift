// swift-tools-version:5.0
import PackageDescription

let pkg = Package(
    name: "JSONClient",

    platforms: [
        .iOS(.v12)
    ],

    products: [
        .library(
            name: "JSONClient",
            targets: ["JSONClient"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/Stylobate.git",
                 .upToNextMajor(from: "0.32.3")),
        .package(url: "https://github.com/OAuthSwift/OAuthSwift.git",
                 .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/mxcl/PromiseKit.git",
                 .upToNextMajor(from: "6.12.0"))
    ],

    targets: [
        .target(name: "JSONClient",
                dependencies: ["Stylobate", "OAuthSwift", "PromiseKit"],
                path: "Source"
        ),
        .testTarget(name: "JSONClientTests",
                    dependencies: ["JSONClient"],
                    path: "Tests"),

    ]
)

