//
//  DeleteToDoUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public protocol DeleteToDoUseCase {
    func execute(id: String) async throws
}

public struct StandardDeleteToDoUseCase: DeleteToDoUseCase {
    @Injected(\.todoRepository)
    var todoRepository
    
    public init() {}
    
    public func execute(id: String) async throws {
        try await todoRepository.deleteToDo(id)
    }
}
