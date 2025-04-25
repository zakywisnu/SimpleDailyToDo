//
//  DailyToDoWidgetLiveActivity.swift
//  DailyToDoWidget
//
//  Created by Ahmad Zaky W on 15/04/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import ToDoSwiftUI

struct DailyToDoWidgetLiveActivity: Widget {
    @State var isAnimating: Bool = false
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DailyToDoActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(context.state.currentTaskCategory.cardColor.gradient)
                
                if context.state.remainingTasks == 0 {
                    NoRemainingTasksView()
                } else {
                    BannerUI(for: context.attributes.userName, contentState: context.state)
                }
            }
            .environment(\.colorScheme, .light)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    expandedLeadingContent(
                        contentState: context.state,
                        animation: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    expandedTrailingContent(for: context.state.remainingTasks)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    expandedBottomContent()
                }
                DynamicIslandExpandedRegion(.center) {
                    expandedCenterContent(
                        for: context.attributes.userName,
                        contentState: context.state
                    )
                }
            } compactLeading: {
                compactLeadingContent(contentState: context.state)
                    .environment(\.colorScheme, .light)
            } compactTrailing: {
                compactTrailingContent(contentState: context.state)
                    .environment(\.colorScheme, .light)
            } minimal: {
                compactLeadingContent(contentState: context.state)
                    .environment(\.colorScheme, .light)
            }
        }
    }
}

fileprivate extension DailyToDoActivityAttributes {
    static var preview: Self {
        .init(userName: "Blue Winter")
    }
}

fileprivate extension DailyToDoActivityAttributes.ContentState {
    static var previewContent: Self {
        .init(remainingTasks: 0, currentTask: "Memanen", currentTaskDescription: "Memanen Ganja", currentTaskCategory: .works)
    }
}

#Preview("Notification", as: .dynamicIsland(.minimal), using: DailyToDoActivityAttributes.preview) {
    DailyToDoWidgetLiveActivity()
} contentStates: {
    DailyToDoActivityAttributes.ContentState.previewContent
}

