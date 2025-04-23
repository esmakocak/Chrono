//
//  MainTabView.swift
//  Chrono
//
//  Created by Esma Koçak on 21.04.2025.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var taskViewModel = TaskViewModel(context: PersistenceController.shared.container.viewContext)

    var body: some View {
        TabView {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            MainTaskView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Tasks")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tint(Color("Burgundy"))
        .environmentObject(taskViewModel)
    }
}

#Preview {
    MainTabView()
}
