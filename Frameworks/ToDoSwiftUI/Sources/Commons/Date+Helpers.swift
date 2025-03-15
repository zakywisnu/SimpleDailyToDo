//
//  Date+Helpers.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 22/02/25.
//

import Foundation

extension Date {
    var currentWeek: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: today) - (calendar.firstWeekday - 1)
        let range = calendar.range(of: .weekday, in: .weekOfYear, for: today)
        let dates = range?.compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        return dates ?? []
    }
    
    var nextWeek: [Date] {
        guard let lastDay = currentWeek.last else { return [] }
        let calendar = Calendar.current
        let nextWeekDay = calendar.date(byAdding: .day, value: 1, to: lastDay)
        return nextWeekDay?.currentWeek ?? []
    }
    
    var previousWeek: [Date] {
        guard let lastDay = currentWeek.first else { return [] }
        let calendar = Calendar.current
        let nextWeekDay = calendar.date(byAdding: .day, value: -calendar.firstWeekday, to: lastDay)
        return nextWeekDay?.currentWeek ?? []
    }
    
    var dayOfWeek: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: today)
        return dayOfWeek == 1 ? 7 : dayOfWeek - 1
    }
    
    static func setDateRange(from startDate: Date, toYears num: Int) -> ClosedRange<Date> {
        let min = startDate
        let max = Calendar.current.date(byAdding: .year, value: num, to: startDate) ?? Date()
        return min...max
    }
    
    static func setDateRange(from startDate: Date, toMonth num: Int) -> ClosedRange<Date> {
        let min = startDate
        let max = Calendar.current.date(byAdding: .month, value: num, to: startDate) ?? Date()
        return min...max
    }
    
    static func setDateRange(from startDate: Date, toDays num: Int) -> ClosedRange<Date> {
        let min = startDate
        let max = Calendar.current.date(byAdding: .day, value: num, to: startDate) ?? Date()
        return min...max
    }
    
    func isInSameDay(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let date1Components = calendar.dateComponents([.year, .month, .day], from: self)
        let date2Components = calendar.dateComponents([.year, .month, .day], from: date)
        return date1Components == date2Components
    }
}

extension Date: @retroactive Identifiable {
    public var id: Double {
        self.timeIntervalSince1970
    }
}
