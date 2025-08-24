//App 進入點，載入 ContentView 並注入 AppState

import SwiftUI

@main
struct MySocialPracticeBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(DS.primaryBlue) // 使用我們的 DesignSystem 主色
        }
    }
}
