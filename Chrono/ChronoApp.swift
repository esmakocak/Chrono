//
//  ChronoApp.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI
import Firebase
import GoogleSignIn
 
@main
struct ChronoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // Uygulama açıldığında çalışacak fonksiyon
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()  // Firebase başlat
        print("Firebase Başarıyla Konfigüre Edildi")
        return true
    }
    
    // Google Sign-In işlemleri için URL yönlendirmeyi işleyen fonksiyon
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
