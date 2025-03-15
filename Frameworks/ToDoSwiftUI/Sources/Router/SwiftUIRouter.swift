//
//  SwiftUIRouter.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import CoreKit
import Foundation
import SwiftUI

protocol SwiftUIRouter {
    func push(to route: AppRouteSwiftUI)
    func pop()
    func popTo(route: AppRouteSwiftUI)
    func setRoot(to route: AppRouteSwiftUI)
    func popToRoot()
}

public protocol Routable {
    var key: String { get }
}

public enum AppRouteSwiftUI: Routable, Hashable {
    
    case splashscreen
    case home
    case auth(AuthRoute)
    case user(UserRoute)
    case todo(ToDoRoute)
    
    public var key: String {
        switch self {
        case .home:
            return "Home Page"
        case let .auth(subRoute):
            return subRoute.key
        case let .user(subRoute):
            return subRoute.key
        case .splashscreen:
            return "Splash Screen Page"
        case let .todo(subRoute):
            return subRoute.key
        }
    }
}

public final class StandardSwiftUIRouter: ObservableObject, SwiftUIRouter {
    @Published var navPath = NavigationPath()
    private var navStack: [AppRouteSwiftUI] = []
    @Published var currentRoot: AppRouteSwiftUI = .splashscreen
    
    public init() {}
    
    // Push a new route onto the stack
    public func push(to route: AppRouteSwiftUI) {
        DispatchQueue.main.async {
            self.navPath.append(route)
            self.navStack.append(route)
        }
    }
    
    // Pop the top route from the stack
    public func pop() {
        DispatchQueue.main.async {
            guard !self.navStack.isEmpty else { return }
            self.navPath.removeLast()
            self.navStack.removeLast()
        }
    }
    
    // Pop to a specific route in the stack
    public func popTo(route: AppRouteSwiftUI) {
        DispatchQueue.main.async {
            if let index = self.navStack.firstIndex(where: { $0 == route }) {
                let elementsToRemove = self.navStack.count - index - 1
                self.navPath.removeLast(elementsToRemove)
                self.navStack.removeLast(elementsToRemove)
            }
        }
    }
    
    // Set the root route (clear the stack and push the new route)
    public func setRoot(to route: AppRouteSwiftUI) {
        DispatchQueue.main.async {
            self.navPath = NavigationPath()
            self.navStack = []
            self.currentRoot = route
            self.navStack.append(route)
        }
    }
    
    // Pop to the root route (clear the stack)
    public func popToRoot() {
        DispatchQueue.main.async {
            self.setRoot(to: .home)
        }
    }
    
    // Ensure HomeView is the root
    public func ensureHomeIsRoot() {
        DispatchQueue.main.async {
            if self.navStack.isEmpty || self.navStack.first != .home {
                self.setRoot(to: .home)
            }
        }
    }
}

