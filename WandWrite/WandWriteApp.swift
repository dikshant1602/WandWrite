//
//  WandWriteApp.swift
//  WandWrite
//
//  Created by FCP35 on 24/01/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct WandWriteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager() // Centralized auth manager

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager) // Pass the auth manager to all views
        }
    }
}
