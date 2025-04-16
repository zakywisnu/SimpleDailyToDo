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
            .project(target: "ToDoSwiftUI", path: "../Frameworks/ToDoSwiftUI/", status: .required, condition: nil),
            .project(target: "CoreKit", path: "../Frameworks/CoreKit/", status: .required, condition: nil),
            .project(target: "DomainKit", path: "../Frameworks/DomainKit/", status: .required, condition: nil),
            .target(name: "DailyToDoWidget")
        ],
        infoPlist: infoPlist,
        resources: ["Resources/**"],
        deploymentTargets: .iOS("18.0"),
        withUnitTest: true
    )
    
    target += Target.create(
        name: "DailyToDoWidget",
        product: .appExtension,
        destination: .iOS,
        dependencies: [],
        infoPlist: ["NSExtension": ["NSExtensionPointIdentifier": "com.apple.widgetkit-extension"]],
        sources: ["DailyToDoWidget/**"],
        deploymentTargets: .iOS("18.0"),
        withUnitTest: false
    )
    return target
}

let project = Project(
    name: "SimpleDailyToDo",
    packages: [],
    targets: targets()
)
