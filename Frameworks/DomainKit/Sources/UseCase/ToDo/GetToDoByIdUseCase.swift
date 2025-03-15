//
//  GetToDoByIdUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public protocol GetToDoByIdUseCase {
    func execute(_ id: String) async throws -> ToDoResponseModel
}

public struct StandardGetToDoByIdUseCase: GetToDoByIdUseCase {
    @Injected(\.todoRepository)
    var todoRepository
    
    public init() {}
    
    public func execute(_ id: String) async throws -> ToDoResponseModel {
        try await todoRepository.getToDoByID(id)
    }
}

