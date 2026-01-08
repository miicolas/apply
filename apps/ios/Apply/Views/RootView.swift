import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {

            DiscoveryView()
                .tabItem {
                    Label("Découverte", systemImage: "sparkles")
                }

            ToApplyView()
                .tabItem {
                    Label("À postuler", systemImage: "tray")
                }

            FollowUpView()
                .tabItem {
                    Label("Suivi", systemImage: "clock")
                }
        }
    }
}
