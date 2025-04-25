import ProjectDescription
import ProjectDescriptionHelpers

func targets() -> [Target] {
    var target: [Target] = []
    target += Target.create(
        name: "ToDoSwiftUI",
        product: .framework,
        destination: [.iPhone, .mac],
        dependencies: [
            .project(target: "DomainKit", path: "../DomainKit", status: .required, condition: nil),
        ],
        resources: ["Resources/**"],
        deploymentTargets: .multiplatform(iOS: "18.0", macOS: "13.6"),
        withUnitTest: true
    )
    return target
}

let project = Project(
    name: "ToDoSwiftUI",
    packages: [],
    targets: targets()
)
