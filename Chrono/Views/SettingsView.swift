//
//  SettingsView.swift
//  Chrono
//
//  Created by Esma Koçak on 21.04.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var viewModel: TaskViewModel
    @StateObject private var settingsVM = SettingsViewModel()
    
    init() {
        _viewModel = StateObject(wrappedValue: TaskViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BgColor").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Top bar
                    HStack {
                        Text("Settings")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("Burgundy"))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .padding(.top)
                    
                    // Settings Content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Timer Mode Card
                            VStack(spacing: 15) {
                                HStack {
                                    Image(systemName: settingsVM.isDeepFocusModeEnabled ? "timer.circle.fill" : "timer")
                                        .font(.title2)
                                        .foregroundColor(Color("Burgundy"))
                                    
                                    Text(settingsVM.isDeepFocusModeEnabled ? "Deep Focus Mode" : "Flexible Mode")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingsVM.isDeepFocusModeEnabled)
                                        .tint(Color("Burgundy"))
                                }
                                
                                Text(settingsVM.isDeepFocusModeEnabled ?
                                    "The countdown will pause when you leave the app." :
                                    "The countdown continues even in background.")
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

#Preview {
    SettingsView()
        .environmentObject(AuthManager())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
