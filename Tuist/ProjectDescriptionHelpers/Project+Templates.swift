//
//  Project+Templates.swift
//  SimpleDailyToDoManifests
//
//  Created by Ahmad Zaky W on 11/02/25.
//

import ProjectDescription

extension Target {
    public static func create(
        name: String,
        product: Product,
        destination: Destinations,
        dependencies: [TargetDependency] = [],
        infoPlist: [String: Plist.Value] = [:],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        deploymentTargets: DeploymentTargets? = nil,
        withUnitTest: Bool = true
    ) -> [Target] {
        return self.project(
            name: name,
            product: product,
            destination: destination,
            dependencies: dependencies,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            deploymentTargets: deploymentTargets,
            withUnitTest: withUnitTest
        )
    }
    
    private static func project(
        name: String,
        product: Product,
        destination: Destinations,
        dependencies: [TargetDependency] = [],
        infoPlist: [String: Plist.Value] = [:],
        sources: SourceFilesList = [],
        resources: ResourceFileElements? = nil,
        deploymentTargets: DeploymentTargets? = nil,
        withUnitTest: Bool = true
    ) -> [Target] {
        var projects: [Target] = []
        let bundleId = product == .appExtension ? "com.zeroemotion.SimpleDailyToDo.\(name)" : "com.zeroemotion.\(name)"
        let mainTarget: Target = .target(
            name: name,
            destinations: destination,
            product: product,
            bundleId: bundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
        
        let unitTestTarget: Target = .target(
            name: "\(name)Tests",
            destinations: destination,
            product: .unitTests,
            bundleId: "com.zeroemotion.\(name)Tests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: "Tests/**",
            dependencies: [
                .target(
                    name: "\(name)"
                )
            ]
        )
        
        projects.append(mainTarget)
        if withUnitTest {
            projects.append(unitTestTarget)
        }
        
        return projects
    }
}
