//
//  UserRoutes.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

public enum UserRoute: Routable, Hashable {
    case profile(Namespace.ID)
    case editProfile(EditProfileRouteParam)

    public var key: String {
        switch self {
        case .profile:
            return "Profile Page"
        case .editProfile:
            return "Edit Profile Page"
        }
    }
}

public extension RootView {
    @ViewBuilder
    func userHandler(_ route: UserRoute) -> some View {
        switch route {
        case let .profile(namespace):
            UserProfileView(namespace: namespace)
        case let .editProfile(param):
            EditProfileView(profile: param.profile, onSuccess: param.onSuccess)
        }
    }
}

public struct EditProfileRouteParam: Hashable {
    public let profile: ProfileModel
    public let onSuccess: () -> Void
    private let id = UUID()
    
    public init(profile: ProfileModel, onSuccess: @escaping () -> Void) {
        self.profile = profile
        self.onSuccess = onSuccess
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: EditProfileRouteParam, rhs: EditProfileRouteParam) -> Bool {
        return lhs.id == rhs.id
    }
}
