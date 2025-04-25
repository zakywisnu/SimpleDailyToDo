//
//  LiveActivityManager.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 17/04/25.
//

import ActivityKit
import DomainKit
import SwiftUI

@available(iOS 16.2, *)
public enum LiveActivityManager {
    public static func startLiveActivity(for userName: String, with todos: [ToDoModel] = []) {
        let attributes = DailyToDoActivityAttributes(userName: userName)
        let state = mapToDosToActivityItems(todos)
        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            do {
                let _ = try Activity<DailyToDoActivityAttributes>.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
            } catch {
                print("Failed to start Live Activity: \(error)")
            }
        }
    }
    
    public static func updateLiveActivity(
        with todos: [ToDoModel] = []
    ) {
        guard LiveActivityManager.isLiveActivityActive() else { return }
        
        Task {
            let state = mapToDosToActivityItems(todos)
            let content = ActivityContent(state: state, staleDate: nil)
            
            for activity in Activity<DailyToDoActivityAttributes>.activities {
                await activity.update(content)
                print("Live Activity updated!")
            }
        }
    }
    
    public static func endLiveActivity() {
        let state = DailyToDoActivityAttributes.ContentState(remainingTasks: 0, currentTaskCategory: .exercise)
        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            for activity in Activity<DailyToDoActivityAttributes>.activities {
                await activity.end(content, dismissalPolicy: .immediate)
                print("Live Activity ended!")
            }
        }
    }
    
    public static func isLiveActivityActive() -> Bool {
        for activity in Activity<DailyToDoActivityAttributes>.activities {
            if !activity.id.isEmpty {
                return true
            }
        }
        return false
    }
    
    private static func mapToDosToActivityItems(_ toDos: [ToDoModel]) -> DailyToDoActivityAttributes.ContentState {
        guard !toDos.isEmpty else {
            return .init(remainingTasks: 0, currentTask: "", currentTaskDescription: "", currentTaskCategory: .exercise)
        }
        let remainingTasks = toDos.filter { $0.status == .incomplete }
        let remainingTasksCount = remainingTasks.count
        let currentTask = remainingTasks.sorted(by: { $0.startDate < $1.startDate }).first
        let tasksTitle = currentTask?.title
        let tasksDescription = currentTask?.description
        let category = currentTask?.todoCategory ?? .exercise
        return .init(
            remainingTasks: remainingTasksCount,
            currentTask: tasksTitle,
            currentTaskDescription: tasksDescription,
            currentTaskCategory: category
        )
    }
}
