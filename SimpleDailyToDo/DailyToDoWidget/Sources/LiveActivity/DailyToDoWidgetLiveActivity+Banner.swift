//
//  DailyToDoLiveActivity+Banner.swift
//  DailyToDoWidget
//
//  Created by Ahmad Zaky W on 24/04/25.
//

import SwiftUI
import ToDoSwiftUI

extension DailyToDoWidgetLiveActivity {
    @ViewBuilder
    func BannerUI(
        for userName: String,
        contentState: DailyToDoActivityAttributes.ToDoActivities
    ) -> some View {
        HStack {
            contentState.currentTaskCategory.image
                .resizable()
                .foregroundStyle(Color.textPrimary)
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading) {
                Text(userName)
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)
                
                Text(contentState.currentTask ?? "")
                    .lineLimit(2)
                    .font(.title3)
                    .foregroundStyle(Color.textPrimary)
                
                Text(contentState.currentTaskDescription ?? "")
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 8) {
                Text("\(contentState.remainingTasks)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                
                Text("Tasks remaining")
                    .foregroundStyle(Color.secondary)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .padding(16)
        .environment(\.colorScheme, .light)
    }
    
    @ViewBuilder
    func NoRemainingTasksView() -> some View {
        HStack(alignment: .center) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.largeTitle)
            VStack(spacing: 8) {
                Text("Congrats, You have no more tasks!")
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(Color.textPrimary)
                
                Text("Keep up the good work!")
                    .font(.subheadline)
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .padding()
        .environment(\.colorScheme, .light)
    }
}
