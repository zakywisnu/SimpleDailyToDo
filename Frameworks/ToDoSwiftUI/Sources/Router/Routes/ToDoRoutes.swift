//
//  ToDoRoutes.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 06/03/25.
//

import SwiftUI

public struct DetailToDoParam: Hashable {
    public let onSuccessDelete: () -> Void
    public let onSuccessUpdate: () -> Void
    private let id = UUID()
    
    public init(onSuccessDelete: @escaping () -> Void, onSuccessUpdate: @escaping () -> Void) {
        self.onSuccessDelete = onSuccessDelete
        self.onSuccessUpdate = onSuccessUpdate
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DetailToDoParam, rhs: DetailToDoParam) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum ToDoRoute: Routable, Hashable {
    case edit
    case detail(String, DetailToDoParam)

    public var key: String {
        switch self {
        case .edit:
            return "Edit ToDo Page"
        case .detail:
            return "Detail ToDo Page"
        }
    }
}

public extension RootView {
    @ViewBuilder
    func todoHandler(_ route: ToDoRoute) -> some View {
        switch route {
        case .edit:
            EmptyView()
        case let .detail(todoId, param):
            ToDoDetailView(todoId, param)
        }
    }
}
