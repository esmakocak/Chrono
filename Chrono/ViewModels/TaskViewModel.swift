//
//  TaskViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    
    init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        tasks = [
            TaskModel(id: UUID(), title: "Reading session", duration: 1800, isCompleted: false, date: Date()),
            TaskModel(id: UUID(), title: "Sport session", duration: 3600, isCompleted: false, date: Date()),
            TaskModel(id: UUID(), title: "Work on project", duration: 7200, isCompleted: true, date: Date()),
            TaskModel(id: UUID(), title: "Clean up", duration: 1500, isCompleted: true, date: Date())
        ]
    }
    
    func toggleCompletion(for task: TaskModel) {
        if let index = tasks.firstIndex(of: task) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func addTask(title: String, duration: TimeInterval) {
        let newTask = TaskModel(id: UUID(), title: title, duration: duration, isCompleted: false, date: Date())
        tasks.append(newTask)
    }
}
