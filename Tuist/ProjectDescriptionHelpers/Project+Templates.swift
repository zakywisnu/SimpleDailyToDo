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
        resources: ResourceFileElements? = nil,
        deploymentTargets: DeploymentTargets? = nil,
        withUnitTest: Bool = true
    ) -> [Target] {
        var projects: [Target] = []
        let mainTarget: Target = .target(
            name: name,
            destinations: destination,
            product: product,
            bundleId: "com.zeroemotion.\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
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
