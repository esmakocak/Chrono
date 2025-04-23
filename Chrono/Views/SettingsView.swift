//
//  SettingsView.swift
//  Chrono
//
//  Created by Esma Koçak on 21.04.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var viewModel: TaskViewModel
    @StateObject private var settingsVM = SettingsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BgColor").ignoresSafeArea()

                VStack(spacing: 20) {
                    // Top bar
                    HStack {
                        Text("Settings")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("Burgundy"))

                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .padding(.top)

                    // Content
                    ScrollView {
                        VStack(spacing: 20) {
                            // 🧠 Focus Mode Picker Card
                            VStack(alignment: .leading, spacing: 15) {
                                Text("⏰ Focus Mode ")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)

                                Picker("Focus Mode", selection: $settingsVM.isDeepFocusModeEnabled) {
                                    Text("Flexible").tag(false)
                                    Text("Deep Focus").tag(true)
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal, 2)
                                .tint(Color("Burgundy"))

                                Text(settingsVM.isDeepFocusModeEnabled
                                     ? "The countdown will pause when you leave the app."
                                     : "The countdown continues even in background.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    SettingsView()
//        .environmentObject(AuthManager())
//        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//}

#Preview {
    SettingsView()
        .environmentObject(TaskViewModel(context: PersistenceController.shared.container.viewContext))
        .environmentObject(AuthManager())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
