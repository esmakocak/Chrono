//
//  CountdownViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import Foundation
import Combine

class CountdownViewModel: ObservableObject {
    let task: TaskModel
    private var timer: Timer?
    
    @Published var timeRemaining: TimeInterval
    @Published var isRunning = true

    var progress: CGFloat {
        CGFloat(1 - (timeRemaining / task.duration))
    }

    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init(task: TaskModel) {
        self.task = task
        self.timeRemaining = task.duration
    }

    func startTimer() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.isRunning else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                // TODO: Bitince görev tamamlandı işaretleme yapılabilir
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func toggleTimer() {
        isRunning.toggle()
    }

    deinit {
        stopTimer()
    }
}
