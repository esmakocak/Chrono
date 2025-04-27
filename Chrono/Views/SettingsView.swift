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
    @State private var showReminderSheet = false

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
                                     ? "Your task progress will be lost if you leave the countdown."
                                     : "Your task progress is saved even if you leave the countdown.")
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
                        
                        // 🔔 Reminder Toggle Card
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🔔 Daily Reminder")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)

                                Spacer()

                                Toggle("", isOn: $settingsVM.reminderEnabled)
                                    .labelsHidden()
                                    .tint(Color("Burgundy"))
                            }

                            Text("Remind me every day to complete my tasks.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if settingsVM.reminderEnabled {
                                Button {
                                    showReminderSheet = true
                                } label: {
                                    VStack {
                                        Divider().padding(.bottom, 10)
                                        
                                        HStack {
                                            Text("Reminder Time")
                                                .foregroundColor(Color("Burgundy"))
                                                .fontWeight(.medium)
                                            Spacer()
                                            Text(String(format: "%02d:%02d", settingsVM.reminderHour, settingsVM.reminderMinute))
                                                .foregroundColor(.black)
                                                .fontWeight(.medium)
                                        }
                                    }
                                }
                                .padding(.top, 5)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        .onChange(of: settingsVM.reminderEnabled) { enabled in
                            if enabled {
                                NotificationManager.shared.scheduleReminder(hour: settingsVM.reminderHour, minute: settingsVM.reminderMinute)
                            } else {
                                NotificationManager.shared.removeReminder()
                            }
                        }
                        
                        .padding(.top)
                    }
                }
            }
        }
        .sheet(isPresented: $showReminderSheet) {
            VStack(spacing: 20) {
                Text("Set Reminder Time")
                    .font(.title3)
                    .bold()
                    .padding()

                DatePicker("", selection: Binding(
                    get: {
                        var components = DateComponents()
                        components.hour = settingsVM.reminderHour
                        components.minute = settingsVM.reminderMinute
                        return Calendar.current.date(from: components) ?? Date()
                    },
                    set: { newDate in
                        let comps = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                        settingsVM.reminderHour = comps.hour ?? 9
                        settingsVM.reminderMinute = comps.minute ?? 0
                        NotificationManager.shared.scheduleReminder(hour: settingsVM.reminderHour,minute: settingsVM.reminderMinute)
                    }
                ), displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()

                Spacer()
            }
            .presentationDetents([.medium])
            .padding()
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
