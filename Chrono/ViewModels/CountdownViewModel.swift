//
//  CountdownViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import Foundation
import Combine

class CountdownViewModel: ObservableObject {
    let task: TaskEntity
    private var timer: Timer?
    
    @Published var timeRemaining: TimeInterval
    @Published var isRunning = false
    
    var onCountdownFinished: (() -> Void)?
    
    
    var progress: CGFloat {
        CGFloat(1 - (timeRemaining / task.duration))
    }
    
    var formattedTime: String {
        let clamped = max(0, Int(timeRemaining)) 
        let hours = clamped / 3600
        let minutes = (clamped % 3600) / 60
        let seconds = clamped % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    init(task: TaskEntity) {
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
                self.timeRemaining = 0
                DispatchQueue.main.async {
                    self.onCountdownFinished?()
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func toggleTimer() {
        if timer == nil {
            startTimer() 
        }
        isRunning.toggle()
    }
    
    deinit {
        stopTimer()
    }
}
