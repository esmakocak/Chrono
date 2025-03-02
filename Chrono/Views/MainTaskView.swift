//
//  MainTaskView.swift
//  Chrono
//
//  Created by Esma Koçak on 1.03.2025.
//

import SwiftUI



struct MainTaskView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack {
            Text("Hoşgeldin")

            Button(action: {
                authManager.signOut()
            }) {
                Text("Çıkış Yap")
                    .foregroundColor(Color("Burgundy"))
                    .padding()
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    MainTaskView()
}
