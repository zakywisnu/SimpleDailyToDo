//
//  WeeklyCalendarViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 22/02/25.
//

import SwiftUI

struct Week: Identifiable, Hashable {
    let id = UUID()
    let dates: [Date]
    
    var firstDate: Date? { dates.first }
    var lastDate: Date? { dates.last }
}

final class WeeklyCalendarViewModel: ObservableObject {
    @Published var state: State
    @Published var selectedDate: Date {
        didSet {
            selectedDateBinding.wrappedValue = selectedDate
        }
    }
    
    private let onUpdateShowWeeks: (Week) -> Void
    
    private let calendar = Calendar.current
    private var selectedDateBinding: Binding<Date>
    
    init(selectedDate: Binding<Date>, onUpdateShowWeeks: @escaping (Week) -> Void) {
        self.selectedDateBinding = selectedDate
        self._selectedDate = Published(initialValue: selectedDate.wrappedValue)
        
        self.onUpdateShowWeeks = onUpdateShowWeeks
        
        let today = calendar.startOfDay(for: Date())
        
        var initialWeeks: [Week] = []
        let startDate = today.addingWeeks(-10)
        
        for i in 0..<21 {
            let weekDates = startDate.addingWeeks(i).currentWeek
            initialWeeks.append(Week(dates: weekDates))
        }
        
        self.state = State(
            weeks: initialWeeks,
            currentIndex: 10
        )
    }
    
    func send(_ action: Action) {
        switch action {
        case .didAddNeededWeeks:
            addNeededWeeks()
        case .didUpdateSelectedDate:
            updateSelectedDate()
        case .didUpdateShowWeeks:
            didUpdateShowWeeks()
        case let .didUpdateTodos(todos):
            didUpdateTodos(todos)
        }
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    func isTaskExists(_ date: Date, week: Week) -> Bool {
        guard week == state.shownWeeks else { return false }
        let data = !state.todos.filter { $0.startDateInDate!.isInSameDay(date) }.isEmpty
        return data
    }
}

extension WeeklyCalendarViewModel {
    func addNeededWeeks() {
        let threshold = 5 // Number of weeks before we add more
        
        if state.currentIndex <= threshold {
            // Add more weeks to the beginning
            var newWeeks = [Week]()
            if let firstWeek = state.weeks.first,
               let firstDate = firstWeek.dates.first {
                for i in 1...threshold {
                    let newDates = firstDate.addingWeeks(-i).currentWeek
                    newWeeks.insert(Week(dates: newDates), at: 0)
                }
                state.weeks.insert(contentsOf: newWeeks, at: 0)
                state.currentIndex += threshold
            }
        } else if state.currentIndex >= state.weeks.count - threshold - 1 {
            // Add more weeks to the end
            if let lastWeek = state.weeks.last,
               let lastDate = lastWeek.dates.first {
                for i in 1...threshold {
                    let newDates = lastDate.addingWeeks(i).currentWeek
                    state.weeks.append(Week(dates: newDates))
                }
            }
        }
    }
    
    func updateSelectedDate() {
        if let currentWeek = state.weeks[safe: state.currentIndex] {
            // Find the same weekday in the new week
            let weekday = calendar.component(.weekday, from: selectedDate)
            if let newDate = currentWeek.dates.first(where: {
                calendar.component(.weekday, from: $0) == weekday
            }) {
                selectedDate = newDate
            }
        }
    }
    
    func didUpdateShowWeeks() {
        onUpdateShowWeeks(state.shownWeeks)
    }
    
    private func didUpdateTodos(_ todos: [ToDoModel]) {
        state.todos = todos
    }
}

extension WeeklyCalendarViewModel {
    struct State {
        var weeks: [Week]
        var currentIndex: Int
        var todos: [ToDoModel] = []
        
        var currentMonthYear: String {
            if let currentWeek = weeks[safe: currentIndex],
               let firstDate = currentWeek.dates.first {
                return firstDate.formatted(Date.FormatStyle()
                    .month(.wide)
                    .year()
                )
            }
            return ""
        }
        
        var shownWeeks: Week {
            return weeks[currentIndex]
        }
    }
    
    enum Action {
        case didAddNeededWeeks
        case didUpdateSelectedDate
        case didUpdateShowWeeks
        case didUpdateTodos([ToDoModel])
    }
}

// Add a safe subscript extension to Array
extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Date {
    func addingWeeks(_ weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self) ?? self
    }
}

