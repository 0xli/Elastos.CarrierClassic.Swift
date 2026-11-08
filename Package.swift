// swift-tools-version:5.9
// Elastos Carrier Swift SDK as shipped by Decent Network (Beagle Chat for iOS).
// The binary is ElastosCarrierSDK.xcframework, built from this branch and the
// native SDK v6.1.0. Docs: https://decent.network/docs/swift-carrier
import PackageDescription

let package = Package(
    name: "ElastosCarrierSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ElastosCarrierSDK", targets: ["ElastosCarrierSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "ElastosCarrierSDK",
            url: "https://github.com/0xli/Elastos.CarrierClassic.Swift/releases/download/6.1.0/ElastosCarrierSDK.xcframework.zip",
            checksum: "635e02b50d8cd7bdf2e2ee226f5cc5f7532bf28f71136069f33ab2917bf26d2d"
        ),
    ]
)
