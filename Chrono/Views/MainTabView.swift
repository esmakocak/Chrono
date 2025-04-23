//
//  MainTabView.swift
//  Chrono
//
//  Created by Esma Koçak on 21.04.2025.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var taskViewModel = TaskViewModel(context: PersistenceController.shared.container.viewContext)
    @State private var selectedTab = 1


    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(0)

            MainTaskView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Tasks")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(Color("Burgundy"))
        .environmentObject(taskViewModel)
    }
}

#Preview {
    MainTabView()
}
