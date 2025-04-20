//
//  TaskModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import Foundation

extension TaskEntity {
    var isToday: Bool {
        guard let date else { return false }
        return Calendar.current.isDateInToday(date)
    }

    var formattedDuration: String {
        let totalMinutes = Int(duration / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }
}


