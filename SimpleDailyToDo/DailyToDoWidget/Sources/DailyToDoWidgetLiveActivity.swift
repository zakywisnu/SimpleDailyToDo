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
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DailyToDoActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.endTime)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.endTime)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.endTime)")
            } minimal: {
                Text("\(context.state.endTime)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

//#Preview("Notification", as: .content, using: DummyWidgetAttributes.preview) {
//    DailyToDoWidgetLiveActivity()
//} contentStates: {
//    DummyWidgetAttributes.ContentState.smiley
//    DummyWidgetAttributes.ContentState.starEyes
//}

