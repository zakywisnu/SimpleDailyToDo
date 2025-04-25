@preconcurrency import ProjectDescription
//    Create an account with "tuist auth" and a project with "tuist project create"
//    then uncomment the section below and set the project full-handle.
//    * Read more: https://docs.tuist.io/guides/quick-start/gather-insights
//
let tuist = Tuist(fullHandle: "azakyw/simpledailytodo", project: .tuist(compatibleXcodeVersions: .all, swiftVersion: nil, plugins: [], generationOptions: .options(), installOptions: .options()))
