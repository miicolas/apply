//
//  ContentView.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("My App")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Welcome to my iOS app")
                    .foregroundStyle(.secondary)

                Button("Get started") {
                    // action plus tard
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
