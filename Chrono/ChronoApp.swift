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
    
    let persistenceController = PersistenceController.shared
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "BgColor")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = UIColor(named: "Burgundy") 
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext) 
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
