//
//  DailyToDoActivityAttributes.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 15/04/25.
//

import ActivityKit
import SwiftUI

public struct DailyToDoActivityAttributes: ActivityAttributes {
    public typealias ToDoActivities = ContentState
    public var userName: String
    
    public struct ContentState: Codable, Hashable {
        public var remainingTasks: Int
        public var currentTask: String?
        public var currentTaskDescription: String?
        public var currentTaskCategory: ToDoCategory
        
        public init(
            remainingTasks: Int,
            currentTask: String? = nil,
            currentTaskDescription: String? = nil,
            currentTaskCategory: ToDoCategory
        ) {
            self.remainingTasks = remainingTasks
            self.currentTask = currentTask
            self.currentTaskDescription = currentTaskDescription
            self.currentTaskCategory = currentTaskCategory
        }
    }
    
    public init(userName: String) {
        self.userName = userName
    }
    
    
}
