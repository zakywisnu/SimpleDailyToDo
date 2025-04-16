//
//  DailyToDoActivityAttributes.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 15/04/25.
//

import ActivityKit
import SwiftUI

public struct DailyToDoActivityAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        public var endTime: Date
        
        public init(endTime: Date) {
            self.endTime = endTime
        }
    }
    
    public init(timerName: String) {
        self.timerName = timerName
    }
    
    public var timerName: String
}
