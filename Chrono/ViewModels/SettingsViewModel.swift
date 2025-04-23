//  SettingsViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("isDeepFocusModeEnabled") var isDeepFocusModeEnabled: Bool = false
} 
