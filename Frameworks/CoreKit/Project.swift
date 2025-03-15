import ProjectDescription
import ProjectDescriptionHelpers

func targets() -> [Target] {
    var target: [Target] = []
    target += Target.create(
        name: "CoreKit",
        product: .framework,
        destination: [.iPhone, .mac],
        dependencies: [
            .external(name: "ZeroNetwork", condition: nil),
            .external(name: "ZeroCoreKit", condition: nil)
        ],
        deploymentTargets: .multiplatform(iOS: "18.0", macOS: "13.6"),
        withUnitTest: true
    )
    return target
}

let project = Project(
    name: "CoreKit",
    packages: [],
    targets: targets()
)
