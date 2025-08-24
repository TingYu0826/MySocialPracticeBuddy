//首頁，顯示今日挑戰卡片與入口

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var app: AppState
    @State private var showDetail = false
    @State private var showSettings = false

    var body: some View {
        let c = app.todayChallenge()

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HomeHeroCard(
                        title: c.title,
                        tip: c.tip,
                        difficulty: c.difficulty,
                        imageName: "home-hero"   // 這裡用你的 Assets 圖片名稱
                    ) { showDetail = true }
                    .padding(.horizontal)
                }
                .padding(.top, 12)
            }
            .background(DS.bg)
            .navigationTitle("首頁")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showSettings = true } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showDetail) {
                ChallengeDetailView(challenge: c).environmentObject(app)
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack { SettingsView().environmentObject(app) }
                    .presentationDetents([.large])
            }
        }
    }
}

private struct HomeHeroCard: View {
    let title: String
    let tip: String
    let difficulty: Difficulty
    let imageName: String
    let onAccept: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // ✅ 圖片鋪滿
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)

            // 標題 + 難度膠囊
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(DS.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                DifficultyChip(difficulty: difficulty)
            }

            // 小提示
            Text(tip)
                .font(.subheadline)
                .foregroundColor(DS.textSecondary)

            // 中等大小主按鈕
            Button("接受挑戰 🚀") { onAccept() }
                .primaryButton(size: .medium)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(18)
        .background(
            Color.white.opacity(0.95)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

private struct DifficultyChip: View {
    let difficulty: Difficulty
    var body: some View {
        Text(label)
            .font(.caption2.bold())
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.25))
            .foregroundColor(.black)
            .clipShape(Capsule())
    }
    private var label: String {
        switch difficulty {
        case .beginner: return "初學者"
        case .advanced: return "進階"
        case .hell:     return "地獄模式"
        }
    }
    private var color: Color {
        switch difficulty {
        case .beginner: return .green
        case .advanced: return .orange
        case .hell:     return .red
        }
    }
}
