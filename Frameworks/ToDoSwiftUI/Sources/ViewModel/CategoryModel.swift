//
//  CategoryModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 21/02/25.
//

import Foundation
import DomainKit

public struct CategoryModel: Identifiable, Hashable {
    public var id: UUID
    public let name: String
    public let color: String
}

extension CategoryModel {
    static var empty: CategoryModel {
        CategoryModel(
            id: UUID(),
            name: "",
            color: ""
        )
    }
}

extension CategoryResponseModel {
    func toModel() -> CategoryModel {
        CategoryModel(
            id: UUID(),
            name: name ?? "",
            color: color ?? ""
        )
    }
}

extension Array where Element == CategoryResponseModel {
    func toModels() -> [CategoryModel] {
        map { $0.toModel() }
    }
}

extension Array where Element == CategoryModel {
    func toToDoCategory() -> [ToDoCategory] {
        map { ToDoCategory(rawValue: $0.name) ?? .exercise }
    }
}
