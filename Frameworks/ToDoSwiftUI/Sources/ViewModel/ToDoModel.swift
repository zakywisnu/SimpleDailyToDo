//
//  ToDoModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 21/02/25.
//

import Foundation
import DomainKit

public struct ToDoModel: Hashable {
    public let todoId: String
    public let title: String
    public let description: String
    public var status: StatusModel
    public let tags: [String]
    public let icon: String
    public let category: CategoryModel
    public let startDate: String
    public let endDate: String
    
    public enum StatusModel: String, Hashable, Comparable {
        public static func < (lhs: ToDoModel.StatusModel, rhs: ToDoModel.StatusModel) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case incomplete
        case complete
    }
}

public extension ToDoModel {
    static var dummy: ToDoModel {
        return ToDoModel(
            todoId: "12312312",
            title: "Dummy model",
            description: "This is Dummy",
            status: .incomplete,
            tags: ["work", "till die"],
            icon: "",
            category: .init(
                id: .init(),
                name: "Works",
                color: ""
            ),
            startDate: Date().ISO8601Format(),
            endDate: Date().ISO8601Format()
            )
    }
    
    var startDateInDate: Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: startDate)
    }
    
    var lastDateInDate: Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: endDate)
    }
    
    var todoCategory: ToDoCategory {
        ToDoCategory(rawValue: category.name) ?? .exercise
    }
    
    var timeRange: String {
        let isoDateFormatter = ISO8601DateFormatter()
        let startDate = isoDateFormatter.date(from: startDate)
        let endDate = isoDateFormatter.date(from: endDate)
        
        if let startDate = startDate, let endDate = endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        }
        return ""
    }
}

extension ToDoResponseModel {
    func toModel() -> ToDoModel {
        return ToDoModel(
            todoId: todoId ?? "",
            title: title ?? "",
            description: description ?? "",
            status: ToDoModel.StatusModel(rawValue: status?.rawValue ?? "") ?? .incomplete,
            tags: tags ?? [],
            icon: icon ?? "",
            category: category?.toModel() ?? .empty,
            startDate: startDate ?? "",
            endDate: endDate ?? ""
        )
    }
}

extension Array where Element == ToDoResponseModel {
    func toModels() -> [ToDoModel] {
        return map { $0.toModel() }
    }
}

extension Array where Element == ToDoModel {
    func getToDosWeek(from minDate: Date, to maxDate: Date) -> [ToDoModel] {
        let dateFormatter = ISO8601DateFormatter()
        return filter { dateFormatter.date(from: $0.startDate)! > minDate }
            .filter { dateFormatter.date(from: $0.endDate)! < maxDate }
    }
    
    var completedCount: Int {
        return filter { $0.status == .complete }.count
    }
}
