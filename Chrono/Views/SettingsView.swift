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

    private let soundOptions: [SoundOption] = [
        SoundOption(label: "None", value: "None"),
        SoundOption(label: "🌧️ Rain", value: "rainSound"),
        SoundOption(label: "🔥 Campfire", value: "campfireSound"),
        SoundOption(label: "🌊 Ocean", value: "oceanSound"),
        SoundOption(label: "🎶 Lo-Fi", value: "lofiSound"),
        SoundOption(label: "🌃 Night", value: "nightSound")
    ]

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
                            focusModeCard
                            reminderCard
                            ambientSoundCard
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
        }
        .sheet(isPresented: $showReminderSheet) {
            reminderSheet
        }
    }

    // MARK: - Cards

    private var focusModeCard: some View {
        settingCard {
            Text("⏰ Focus Mode")
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
        }
    }

    private var reminderCard: some View {
        settingCard {
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
        .onChange(of: settingsVM.reminderEnabled) { enabled in
            if enabled {
                NotificationManager.shared.scheduleReminder(hour: settingsVM.reminderHour, minute: settingsVM.reminderMinute)
            } else {
                NotificationManager.shared.removeReminder()
            }
        }
    }

    private var ambientSoundCard: some View {
        settingCard {
            Text("🎧 Ambient Sound")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Text("Choose a background sound for your focus sessions.")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            Picker("Select Sound", selection: $settingsVM.selectedAmbientSound) {
                ForEach(soundOptions) { sound in
                    Text(sound.label).tag(sound.value)
                }
            }
            .pickerStyle(.menu)
            .padding(.leading, -12)
            .tint(Color("Burgundy"))
        }
    }
    
    // MARK: - Reminder Sheet

    private var reminderSheet: some View {
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
                    NotificationManager.shared.scheduleReminder(hour: settingsVM.reminderHour,
                                                                minute: settingsVM.reminderMinute)
                }
            ), displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
            .labelsHidden()

            Spacer()
        }
        .presentationDetents([.medium])
        .padding()
    }

    // MARK: - Generic Card Wrapper

    private func settingCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15, content: content)
            .padding()
            .frame(width: 380, alignment: .top)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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

struct SoundOption: Identifiable, Hashable {
    var id: String { value } // ForEach için
    let label: String
    let value: String
}
