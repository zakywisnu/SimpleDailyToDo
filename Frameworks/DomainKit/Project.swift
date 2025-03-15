import ProjectDescription
import ProjectDescriptionHelpers

func targets() -> [Target] {
    var target: [Target] = []
    target += Target.create(
        name: "DomainKit",
        product: .framework,
        destination: [.iPhone, .mac],
        dependencies: [
            .project(target: "CoreKit", path: "../CoreKit/", status: .none, condition: nil),
        ],
        deploymentTargets: .multiplatform(iOS: "18.0", macOS: "13.6"),
        withUnitTest: true
    )
    return target
}

let project = Project(
    name: "DomainKit",
    packages: [],
    targets: targets()
)
