//
//  DailyToDoWidgetLiveActivity+Compact.swift
//  DailyToDoWidget
//
//  Created by Ahmad Zaky W on 24/04/25.
//

import SwiftUI
import ToDoSwiftUI
import WidgetKit

extension DailyToDoWidgetLiveActivity {
    @ViewBuilder
    func compactLeadingContent(
        contentState: DailyToDoActivityAttributes.ToDoActivities
    ) -> some View {
        if contentState.remainingTasks > 0 {
            contentState.currentTaskCategory.image
                .resizable()
                .foregroundStyle(Color.textPrimary)
                .frame(width: 16, height: 16)
                .padding(4)
                .background(
                    Circle()
                        .fill(contentState.currentTaskCategory.cardColor)
                )
                .environment(\.colorScheme, .light)
        } else {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundStyle(.green)
                .frame(width: 24, height: 24)
        }
    }
    
    @ViewBuilder
    func compactTrailingContent(
        contentState: DailyToDoActivityAttributes.ToDoActivities
    ) -> some View {
        Text("\(contentState.remainingTasks)")
            .padding(.horizontal, 8)
            .padding(4)
            .background(
                Circle()
                    .fill(contentState.currentTaskCategory.cardColor)
            )
    }
}
