import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("isDeepFocusModeEnabled") var isDeepFocusModeEnabled: Bool = false
} 