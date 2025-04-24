//
//  HapticManager.swift
//  Chrono
//
//  Created by Esma Koçak on 23.04.2025.
//

import Foundation
import UIKit

class HapticsManager {
    static let shared = HapticsManager()
    
    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
