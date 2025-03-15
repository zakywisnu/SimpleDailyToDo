//
//  AuthRoutes.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

public struct RegisterRouteParam: Hashable {
    public let onSuccessRegister: (String) -> Void
    private let id = UUID()
    
    public init(onSuccessRegister: @escaping (String) -> Void) {
        self.onSuccessRegister = onSuccessRegister
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: RegisterRouteParam, rhs: RegisterRouteParam) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum AuthRoute: Routable, Hashable {
    case login
    case register(RegisterRouteParam)
    
    public var key: String {
        switch self {
        case .login:
            return "Login Page"
        case .register:
            return "Register Page"
        }
    }
}

extension RootView {
    @ViewBuilder
    func authHandler(_ route: AuthRoute) -> some View {
        switch route {
        case .login:
            LoginView()
        case let .register(param):
            RegisterView(param.onSuccessRegister)
        }
    }
}
