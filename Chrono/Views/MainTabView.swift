//
//  MainTabView.swift
//  Chrono
//
//  Created by Esma Koçak on 21.04.2025.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // 📅 Calendar
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            // ✅ Tasks
            MainTaskView()
                .tabItem {
                    Image(systemName: "widget.small")
                    Text("Tasks")
                }

            // ⚙️ Settings
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tint(Color("Burgundy")) 
    }
}

#Preview {
    MainTabView()
}
