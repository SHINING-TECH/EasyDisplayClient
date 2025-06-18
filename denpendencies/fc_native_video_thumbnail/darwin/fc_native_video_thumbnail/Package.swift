// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fc_native_video_thumbnail",
    platforms: [
        .iOS("12.0"),
        .macOS("10.15"),
    ],
    products: [
        .library(name: "fc-native-video-thumbnail", targets: ["fc_native_video_thumbnail"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "fc_native_video_thumbnail",
            dependencies: [],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),

                // If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ]
        )
    ]
)
