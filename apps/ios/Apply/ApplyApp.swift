//
//  ApplyApp.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI
import BetterAuth
import BetterAuthEmailOTP

@main
struct ApplyApp: App {
    @StateObject private var authClient = BetterAuthClient(
        baseURL: URL(string: "http://localhost:3000")!,
        scheme: "apply",
        plugins: [EmailOTPPlugin()]
    )
    
    var body: some Scene {
        WindowGroup {
            EntryView()
                .environmentObject(authClient)
                .task {
                    await authClient.session.refreshSession()
                }
        }
    }
}

struct EntryView: View {
    @EnvironmentObject var authClient: BetterAuthClient
    
    var body: some View {
        if authClient.session.data?.user != nil {
            RootView()
                .environmentObject(authClient)
        } else {
            AuthView()
                .environmentObject(authClient)
        }
    }
}
