//
//  GetToDoListUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public protocol GetToDoListUseCase {
    func execute() async throws -> [ToDoResponseModel]
}

public struct StandardGetToDoListUseCase: GetToDoListUseCase {
    @Injected(\.todoRepository)
    var todoRepository
    
    public init() {}
    
    public func execute() async throws -> [ToDoResponseModel] {
        try await todoRepository.getToDoLists()
    }
}
