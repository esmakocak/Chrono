//
//  ContentView.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authManager = AuthManager()

    var body: some View {
        if authManager.user != nil {
            MainTaskView()
        } else {
            WelcomeView() 
        }
    }
}

#Preview {
    ContentView()
}
