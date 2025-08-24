//App 主容器，放置 TabBar 與 Onboarding 流程

import SwiftUI

struct ContentView: View {
    @StateObject private var app = AppState()

    var body: some View {
        TabView {
            HomeView().environmentObject(app)
                .tabItem { Label("首頁", systemImage: "house") }
            CommunityView().environmentObject(app)
                .tabItem { Label("社群", systemImage: "person.2") }
            AchievementsView().environmentObject(app)
                .tabItem { Label("成就", systemImage: "trophy") }
            SettingsView().environmentObject(app)
                .tabItem { Label("設定", systemImage: "gearshape") }
        }
        .onAppear { app.presentOnboardingOnLaunch() }
        .sheet(isPresented: $app.showOnboardingNow) {
            OnboardingView(showOnboarding: $app.showOnboardingNow)
                .presentationDetents([.fraction(0.9)])
        }
        .background(DS.bg.ignoresSafeArea()) 
        .tint(DS.primaryBlue)
    }
}


#Preview {
    ContentView()
}
