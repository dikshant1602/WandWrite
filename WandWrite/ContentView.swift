//
//  ContentView.swift
//  WandWrite
//
//  Created by FCP35 on 24/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                HomePage()
            } else {
                WandwriteWelcomeView()
            }
        }
        .onAppear {
            authManager.checkAuthStatusOnLaunch() // Check auth status when the app starts
        }
    }
}
