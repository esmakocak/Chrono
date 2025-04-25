//
//  CountdownViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import Foundation
import Combine
import SwiftUI

class CountdownViewModel: ObservableObject {
    let task: TaskEntity
    
    @Published var timeRemaining: TimeInterval = 0
    @Published var isRunning = false
    
    @AppStorage("isDeepFocusModeEnabled") private var isDeepFocusModeEnabled: Bool = false
    
    private var timer: Timer?
    private var endDate: Date?
    private var wasBackgrounded = false
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func startTimer() {
        if endDate == nil {
            endDate = Date().addingTimeInterval(timeRemaining)
        }
        isRunning = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimeRemaining()
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func toggleTimer() {
        isRunning ? stopTimer() : startTimer()
    }
    
    private func updateTimeRemaining() {
        guard let endDate = endDate else { return }
        timeRemaining = endDate.timeIntervalSinceNow
        
        if timeRemaining <= 0 {
            timeRemaining = 0
            stopTimer()
            DispatchQueue.main.async {
                self.onCountdownFinished?()
            }
        }
    }

    // Uygulama arka plana geçerse
    @objc private func didEnterBackground() {
        wasBackgrounded = true
    }

    @objc private func willEnterForeground() {
        if wasBackgrounded {
            wasBackgrounded = false

        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
