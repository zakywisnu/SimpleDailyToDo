//
//  DailyToDoLiveActivity+Expanded.swift
//  DailyToDoWidget
//
//  Created by Ahmad Zaky W on 24/04/25.
//

import SwiftUI
import ToDoSwiftUI
import WidgetKit

extension DailyToDoWidgetLiveActivity {
    @ViewBuilder
    func expandedBottomContent() -> some View {
        VStack {
            Text("You can do it!")
                .font(.headline)
                .foregroundStyle(Color.textPrimary)
        }
    }
    
    @ViewBuilder
    func expandedLeadingContent(
        contentState: DailyToDoActivityAttributes.ToDoActivities,
        animation: Bool
    ) -> some View {
        VStack(alignment: .center) {
            Spacer()
            if contentState.remainingTasks > 0 {
                contentState.currentTaskCategory.image
                    .resizable()
                    .symbolEffect(.pulse, options: .repeat(.continuous), value: animation)
                    .foregroundStyle(Color.textPrimary)
                    .frame(width: 48, height: 48)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .symbolEffect(.pulse, options: .repeat(.continuous), value: animation)
                    .frame(width: 48, height: 48)
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func expandedTrailingContent(
        for remainingTasks: Int
    ) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer()
            Text("\(remainingTasks)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.red)
            
            Text("Tasks remaining")
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.secondary)
                .font(.caption)
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    @ViewBuilder
    func expandedCenterContent(
        for userName: String,
        contentState: DailyToDoActivityAttributes.ToDoActivities
    ) -> some View {
        VStack(alignment: .center) {
            Text(userName)
                .font(.caption)
                .foregroundStyle(Color.textPrimary)
            
            Text(contentState.currentTask ?? "")
                .lineLimit(2)
                .font(.headline)
                .foregroundStyle(Color.textPrimary)
            
            Text(contentState.currentTaskDescription ?? "")
                .font(.subheadline)
                .foregroundStyle(Color.textPrimary)
        }
    }
}
