//
//  ToDoCard.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 23/02/25.
//

import SwiftUI

extension HomeView {
    struct ToDoCard: View {
        let task: ToDoModel
        let onUpdateStatus: (ToDoModel) -> Void
        
        var body: some View {
            VStack(spacing: 8) {
                HStack(alignment: .center, spacing: 16) {
                    icon
                    taskDetails
                    
                    Spacer()
                    
                    Text(task.status.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(Color.textPrimary)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(task.status == .complete ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
                        )
                }
                .padding(16)
                
                tags
                    .padding(.horizontal, 16)
                
                HStack {
                    time
                    
                    Spacer()
                    
                    Button {
                        onUpdateStatus(task)
                    } label: {
                        Text("Mark as \(getUpdateStatusTitle().rawValue.capitalized)")
                            .font(.subheadline)
                            .foregroundStyle(Color.textPrimary)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.6))
                            )
                    }

                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(task.todoCategory.cardColor)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 2, y: 2)
            )
        }
        
        private var icon: some View {
            task.todoCategory.image
                .resizable()
                .foregroundStyle(Color.primary)
                .frame(width: 24, height: 24)
        }
        
        private var taskDetails: some View {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                
                Text(task.description)
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        
        private var time: some View {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "clock")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.primary)
                
                Text(task.timeRange)
                    .font(.subheadline)
                    .foregroundColor(Color.textPrimary)
            }
        }
        
        private func getUpdateStatusTitle() -> ToDoModel.StatusModel {
            if task.status == .complete {
                return .incomplete
            } else {
                return .complete
            }
        }
        
        private var tags: some View {
            HStack {
                ForEach(task.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .foregroundColor(Color.textPrimary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

enum ToDoCategory: String, Hashable {
    case works = "Works"
    case learn = "Learn"
    case exercise = "Exercise"
    
    var cardColor: Color {
        switch self {
        case .works:
            return Color.blueCardBackground
        case .learn:
            return Color.pinkCardBackground
        case .exercise:
            return Color.yellowCardBackground
        }
    }
    
    var image: Image {
        switch self {
        case .exercise:
            return Image.exercise
        case .works:
            return Image.work
        case .learn:
            return Image.learn
        }
    }
}
