//
//  CalendarViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 23.04.2025.
//

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var selectedDate: Date?
    private let calendar = Calendar.current
    let viewModel: TaskViewModel

    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        let today = Calendar.current.startOfDay(for: Date())
        self.currentDate = today
        self.selectedDate = today
    }

    var currentMonthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else { return [] }
        var dates: [Date] = []
        var date = monthInterval.start
        while date < monthInterval.end {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }

    var leadingSpaces: Int {
        guard let firstDate = currentMonthDates.first else { return 0 }
        let weekday = calendar.component(.weekday, from: firstDate)
        let adjusted = weekday - calendar.firstWeekday
        return adjusted < 0 ? adjusted + 7 : adjusted
    }

    var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        return Array(symbols[first...] + symbols[..<first])
    }

    func ratio(for date: Date) -> Double {
        let stats = viewModel.completionStats()
        return stats[calendar.startOfDay(for: date)] ?? 0.0
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func isSelected(_ date: Date) -> Bool {
        guard let selected = selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selected)
    }

    func select(_ date: Date) {
        selectedDate = calendar.startOfDay(for: date)
    }

    func goToPreviousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        selectedDate = nil
    }

    func goToNextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        selectedDate = nil
    }
    
    func setMonth(_ month: Int, year: Int) {
        let components = DateComponents(year: year, month: month + 1) // Swift'te aylar 0 tabanlı değil
        if let newDate = Calendar.current.date(from: components) {
            currentDate = newDate
            selectedDate = nil
        }
    }
    
    func incrementYear(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .year, value: value, to: currentDate) {
            currentDate = newDate
        }
    }

    func stats(for date: Date) -> (completed: [TaskEntity], incomplete: [TaskEntity], formattedTime: String, percentage: Int) {
        let all = viewModel.tasksByDate()[date] ?? []
        let completed = all.filter { $0.isCompleted }
        let incomplete = all.filter { !$0.isCompleted }

        let totalSeconds = completed.reduce(0) { $0 + Int($1.duration) }
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let formatted = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
        let percentage = all.isEmpty ? 0 : Int(Double(completed.count) / Double(all.count) * 100)

        return (completed, incomplete, formatted, percentage)
    }
}
