import PackageDescription

let package = Package(
    name: "VaporServer",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/OpenKitten/MongoKitten.git", majorVersion: 1, minor: 7),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

