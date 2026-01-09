//
//  EntryView.swift
//  Apply
//

import SwiftUI

struct EntryView: View {
    @ObservedObject private var authService = AuthService.shared
    @State private var isCheckingSession = true

    var body: some View {
        Group {
            if isCheckingSession {
                ProgressView()
                    .task {
                        await authService.refreshSession()
                        isCheckingSession = false
                    }
            } else if authService.isAuthenticated {
                RootView()
            } else {
                AuthView()
            }
        }
    }
}
