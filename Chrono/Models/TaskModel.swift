//
//  TaskModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import Foundation

struct TaskModel: Identifiable, Hashable {
    let id: UUID
    var title: String
    var duration: TimeInterval
    var isCompleted: Bool
    var date: Date
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
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


