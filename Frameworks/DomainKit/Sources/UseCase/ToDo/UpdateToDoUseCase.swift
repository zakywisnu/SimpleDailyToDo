//
//  UpdateToDoUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public struct UpdateToDoParam: Codable {
    public let title: String
    public let description: String?
    public let status: Status
    public let tags: [String]?
    public let icon: String
    public let category: String
    public let startDate: String
    public let endDate: String
    
    public enum Status: String, Codable {
        case incomplete
        case complete
    }
    
    public init(
        title: String,
        description: String?,
        status: Status,
        tags: [String]?,
        icon: String,
        category: String,
        startDate: String,
        endDate: String
        
    ) {
        self.title = title
        self.description = description
        self.status = status
        self.tags = tags
        self.icon = icon
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
    }
}

public protocol UpdateToDoUseCase {
    @discardableResult func execute(_ param: UpdateToDoParam, _ id: String) async throws -> ToDoResponseModel
}

public struct StandardUpdateToDoUseCase: UpdateToDoUseCase {
    @Injected(\.todoRepository)
    var todoRepository: ToDoRepository
    
    public init() {}
    
    @discardableResult
    public func execute(_ param: UpdateToDoParam, _ id: String) async throws -> ToDoResponseModel {
        guard let response = try await todoRepository.updateToDo(param, id) else {
            return ToDoResponseModel(todoId: nil, title: nil, description: nil, status: nil, tags: nil, icon: nil, category: nil, startDate: nil, endDate: nil)
        }
        return response
    }
}


