//  SettingsViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("isDeepFocusModeEnabled") var isDeepFocusModeEnabled = false
    @AppStorage("reminderEnabled") var reminderEnabled = false
    @AppStorage("reminderHour") var reminderHour: Int = 9
    @AppStorage("reminderMinute") var reminderMinute: Int = 0
}
