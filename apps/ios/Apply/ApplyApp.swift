//
//  ApplyApp.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI

@main
struct ApplyApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                RootView()
                    .environmentObject(authViewModel)
            } else {
                AuthView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
