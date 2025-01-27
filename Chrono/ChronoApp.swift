//
//  ChronoApp.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI
import Firebase

@main
struct ChronoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("succeed")
        
        return true
    }
}
