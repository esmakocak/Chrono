//
//  TaskViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import Foundation
import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskEntity] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchTasks()
    }

    func fetchTasks() {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)]

        do {
            tasks = try context.fetch(request)
        } catch {
            print("Görevler alınamadı: \(error.localizedDescription)")
        }
    }

    func addTask(title: String, duration: TimeInterval) {
        let task = TaskEntity(context: context)
        task.id = UUID()
        task.title = title
        task.duration = duration
        task.date = Date()
        task.isCompleted = false

        saveContext()
    }

    func toggleCompletion(for task: TaskEntity) {
        task.isCompleted.toggle()
        saveContext()
    }

    func complete(task: TaskEntity) {
        task.isCompleted = true
        saveContext()
    }

    func delete(task: TaskEntity) {
        context.delete(task)
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
            fetchTasks() // Güncellemeleri anında yansıt
        } catch {
            print("Kaydetme hatası: \(error.localizedDescription)")
        }
    }
    
    func tasksByDate() -> [Date: [TaskEntity]] {
        let calendar = Calendar.current
        var grouped: [Date: [TaskEntity]] = [:]

        for task in tasks {
            if let date = task.date {
                let day = calendar.startOfDay(for: date)
                grouped[day, default: []].append(task)
            }
        }

        return grouped
    }

    func completionStats() -> [Date: Double] {
        let grouped = tasksByDate()
        var stats: [Date: Double] = [:]

        for (day, dayTasks) in grouped {
            let completed = dayTasks.filter { $0.isCompleted }.count
            let total = dayTasks.count
            stats[day] = total == 0 ? 0.0 : Double(completed) / Double(total)
        }

        return stats
    }
}
