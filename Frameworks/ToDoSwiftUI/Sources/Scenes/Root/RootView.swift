//
//  RootView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

public struct RootView: View {
    @StateObject private var router: StandardSwiftUIRouter = StandardSwiftUIRouter()
    @StateObject private var viewModel: RootViewModel
    @Namespace var namespace
    
    public init(viewModel: RootViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack(path: $router.navPath) {
            handleRootView()
            .environmentObject(router)
            .navigationDestination(for: AppRouteSwiftUI.self) { route in
                switch route {
                case let .auth(subRoute):
                    authHandler(subRoute)
                        .environmentObject(router)
                case .home:
                    HomeView(namespace: namespace)
                case let .user(subRoute):
                    userHandler(subRoute)
                        .environmentObject(router)
                case .splashscreen:
                    SplashScreenView()
                case let .todo(subRoute):
                    todoHandler(subRoute)
                        .environmentObject(router)
                }
            }
        }
    }
    
    @ViewBuilder
    private func handleRootView() -> some View {
        switch router.currentRoot {
        case .splashscreen:
            SplashScreenView()
        case .home:
            HomeView(namespace: namespace)
        case .auth:
            authHandler(.login)
        case .user:
            EmptyView()
        case .todo:
            EmptyView()
        }
    }
}

// MARK: - Environment Key for Namespace
struct NamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

extension EnvironmentValues {
    var namespace: Namespace.ID? {
        get { self[NamespaceKey.self] }
        set { self[NamespaceKey.self] = newValue }
    }
}

#Preview {
    RootView(viewModel: RootViewModel())
}
