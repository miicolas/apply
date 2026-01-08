//
//  EntryView.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject private var authService = AuthService.shared
    @StateObject private var opportunitiesVM = OpportunitiesViewModel()
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
                    .environmentObject(opportunitiesVM)
                    .onChange(of: authService.isAuthenticated) { _, isAuth in
                        if !isAuth {
                            opportunitiesVM.clearAll()
                        }
                    }
            } else {
                AuthView()
                    .onAppear {
                        opportunitiesVM.clearAll()
                    }
            }
        }
    }
}
