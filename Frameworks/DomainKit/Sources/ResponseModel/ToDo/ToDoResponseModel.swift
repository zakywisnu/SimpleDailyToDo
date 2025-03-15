//
//  ToDoResponseModel.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation

public struct ToDoResponseModel: Codable {
    public let todoId: String?
    public let title: String?
    public let description: String?
    public let status: StatusResponseModel?
    public let tags: [String]?
    public let icon: String?
    public let category: CategoryResponseModel?
    public let startDate: String?
    public let endDate: String?
    
    public enum StatusResponseModel: String, Codable {
        case incomplete
        case complete
    }
}
