import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist: [String: Plist.Value] = [
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": true,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ]
            ]
        ]
    ],
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1"
]

func targets() -> [Target] {
    var target: [Target] = []
    target += Target.create(
        name: "SimpleDailyToDo",
        product: .app,
        destination: .iOS,
        dependencies: [
            .project(target: "DomainKit", path: "../Frameworks/DomainKit/", status: .required, condition: nil)
        ],
        infoPlist: infoPlist,
        resources: ["Resources/**"],
        deploymentTargets: .iOS("16.0"),
        withUnitTest: true
    )
    return target
}

let project = Project(
    name: "SimpleDailyToDo",
    packages: [],
    targets: targets()
)
