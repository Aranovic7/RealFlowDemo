//
//  RealFlowApp.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-02-18.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
      }
}

@main
struct RealFlowApp: App {
    @AppStorage("isDarkMode") var isDark: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    var body: some Scene {
        WindowGroup {
         //   Environment(\.colorScheme, isDark ? .dark : .light) {
                ContentView()
                .preferredColorScheme(isDark ? .dark : .light)
         //   }
            
        }
        
    }
}

