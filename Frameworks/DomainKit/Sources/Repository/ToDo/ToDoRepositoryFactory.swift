//
//  ToDoRepositoryFactory.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public final class ToDoRepositoryFactory {
    public class func create() -> ToDoRepository {
        ToDoRepositoryKey.currentValue
    }
}

struct ToDoRepositoryKey: InjectedKey {
    static var currentValue: ToDoRepository = StandardToDoRepository()
}

public extension InjectedValues {
    var todoRepository: ToDoRepository {
        get { ToDoRepositoryKey.currentValue }
        set { ToDoRepositoryKey.currentValue = newValue }
    }
}
