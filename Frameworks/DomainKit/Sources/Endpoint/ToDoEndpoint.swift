//
//  ToDoEndpoint.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation
import CoreKit

public struct ToDoEndpoint: RemoteEndpoint {
    public var path: String
    
    public init(path: String) {
        self.path = path
    }
    
    // MARK: Profile
    static let register = ToDoEndpoint(path: "register")
    static let login = ToDoEndpoint(path: "login")
    static let logout = ToDoEndpoint(path: "logout")
    static let profile = ToDoEndpoint(path: "profile")
    static let updateProfile = ToDoEndpoint(path: "profile/update")
    
    // MARK: Categories
    static let category = ToDoEndpoint(path: "category")
    
    // MARK: ToDos
    static let todo = ToDoEndpoint(path: "todo")
    static func todo(_ id: String) -> ToDoEndpoint {
        ToDoEndpoint(path: "todo/\(id)")
    }
}
