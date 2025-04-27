//
//  NotificationManager.swift
//  Chrono
//
//  Created by Esma Koçak on 27.04.2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = "👋 Time to focus!"
            content.body = "Let’s complete your tasks for today 💪"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
            center.add(request)
        }
    }

    func removeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
    }
}
