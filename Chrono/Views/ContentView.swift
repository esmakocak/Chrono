//
//  ContentView.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        if authManager.user != nil {
            MainTaskView()
        } else {
            WelcomeView()
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthManager())
}
