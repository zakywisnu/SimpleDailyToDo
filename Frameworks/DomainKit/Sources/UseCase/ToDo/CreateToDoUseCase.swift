//
//  CreateToDoUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public struct CreateToDoParam: Codable {
    public let title: String
    public let description: String?
    public let status: Status.RawValue
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
        status: Status = .incomplete,
        tags: [String]?,
        icon: String,
        category: String,
        startDate: String,
        endDate: String
    ) {
        self.title = title
        self.description = description
        self.status = status.rawValue
        self.tags = tags
        self.icon = icon
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
    }
}

public protocol CreateToDoUseCase {
    func execute(_ param: CreateToDoParam) async throws
}

public struct StandardCreateToDoUseCase: CreateToDoUseCase {
    @Injected(\.todoRepository)
    var todoRepository: ToDoRepository
    
    public init() {}
    
    public func execute(_ param: CreateToDoParam) async throws {
        try await todoRepository.createToDo(param)
    }
}


