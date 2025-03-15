//
//  WeeklyCalendarView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 21/02/25.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @StateObject var viewModel: WeeklyCalendarViewModel
    @Binding var todos: [ToDoModel]
    
    init(
        selectedDate: Binding<Date>,
        todos: Binding<[ToDoModel]>,
        _ onUpdateShowWeeks: @escaping (Week) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: WeeklyCalendarViewModel(selectedDate: selectedDate, onUpdateShowWeeks: onUpdateShowWeeks))
        _todos = todos
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(viewModel.state.currentMonthYear)
                .font(.title3)
                .fontWeight(.bold)
                .padding([.leading, .trailing], 20.0)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 0) {
                Image(systemName: "chevron.left")
                    .padding(.leading, 12)
                    .foregroundStyle(Color.primary)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.3)) {
                            viewModel.state.currentIndex -= 1
                            viewModel.send(.didAddNeededWeeks)
                        }
                    }
                
                TabView(selection: $viewModel.state.currentIndex) {
                    ForEach(Array(viewModel.state.weeks.enumerated()), id: \.element) { index, week in
                        WeekView(viewModel: viewModel, week: week)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                Image(systemName: "chevron.right")
                    .padding(.trailing, 16)
                    .foregroundStyle(Color.primary)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.3)) {
                            viewModel.state.currentIndex += 1
                            viewModel.send(.didAddNeededWeeks)
                        }
                    }
            }
            .frame(height: 70)
        }
        .onFirstAppear {
            viewModel.send(.didUpdateShowWeeks)
        }
        .onChange(of: viewModel.state.shownWeeks) {
            viewModel.send(.didUpdateShowWeeks)
        }
        .onChange(of: todos) { _, todos in
            viewModel.send(.didUpdateTodos(todos))
        }
    }
}

private struct WeekView: View {
    @ObservedObject var viewModel: WeeklyCalendarViewModel
    let week: Week
    var body: some View {
        HStack {
            ForEach(week.dates) { date in
                DayView(
                    date: date,
                    selectedDate: Binding(
                        get: { viewModel.selectedDate },
                        set: { viewModel.selectedDate = $0 }
                    ),
                    isTasksExiste: viewModel.isTaskExists(date, week: week)
                )
            }
        }
        .padding([.leading, .trailing], 20.0)
        .background {
            GeometryReader { proxy in
                let minX = proxy.frame(in: .global).minX
                Color.clear
                    .preference(key: WeekViewOffsetKey.self, value: minX)
                    .onPreferenceChange(WeekViewOffsetKey.self, perform: { value in
                        if value == 0.0 {
                            viewModel.send(.didAddNeededWeeks)
                            viewModel.send(.didUpdateSelectedDate)
                        }
                    })
            }
        }
    }
}

private struct DayView: View {
    let date: Date
    @Binding var selectedDate: Date
    private var isSelected: Bool { date == selectedDate }
    let isTasksExiste: Bool?
    
    var body: some View {
        VStack(spacing: 8) {
            Text(date.formatted(Date.FormatStyle().weekday(.abbreviated)))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color.textSecondary)
            
            Text(date.formatted(Date.FormatStyle().day()))
                .font(.system(size: 20, weight: .medium))
                .background(
                    Circle()
                        .fill(isSelected ? Color.primary : Color.clear)
                        .frame(width: 32, height: 32)
                )
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.bottom, 4)
            
            if let isTasksExiste {
                Circle()
                    .fill(isTasksExiste ? Color.primary : Color.clear)
                    .frame(width: 6, height: 6)
            }
            
        }
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                selectedDate = date
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct WeekViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
