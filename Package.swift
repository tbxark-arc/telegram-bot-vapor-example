// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "telegram-bot-vapor-example",
    dependencies: [
        // Telegram api
        .package(url: "https://github.com/TBXark/swift-telegram-bot-api.git", from: "1.0.1"),
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "TelegramBotAPI"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

