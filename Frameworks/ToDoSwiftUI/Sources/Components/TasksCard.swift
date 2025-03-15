//
//  TasksCard.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 21/02/25.
//

import SwiftUI
import DomainKit

struct TasksCard: View {
    @Binding var todos: [ToDoModel]
    let title: String
    @State var progress: Double = 0
    
    var body: some View {
        HStack {
            composeProgress(title: title)
                .padding(.horizontal, 16)
        }
    }
    
    private func composeProgress(title: String) -> some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
                .padding(.bottom, 8)
            
            CircularProgressBar(linewidth: 20, progress: progress)
                .frame(width: 120, height: 120)
            
            Text("Tasks Progress")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            
            Text("\(todos.completedCount) out of \(todos.count) completed")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundStyle(Color.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .onChange(of: todos) {
            getProgress()
        }
    }
    
    private func getProgress() {
        if todos.isEmpty {
            progress = 1
        } else {
            progress = Double(todos.completedCount) / Double(todos.count)
        }
    }
}
