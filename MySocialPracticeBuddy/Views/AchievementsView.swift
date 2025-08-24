//成就與頭銜頁，展示徽章與頭銜（靜態）

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        // 直接從 posts 計算，不呼叫任何 AppState 方法
        let days = Set(app.posts.map { $0.dateKey }).count
        let hell = app.posts.filter {
            // 你之前在 AppState 的判斷邏輯：文字中含這些關鍵字就當作地獄級
            $0.text.contains("電話") || $0.text.contains("地獄") || $0.text.contains("核爆")
        }.count

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("我的頭銜和徽章")
                        .font(.title2.bold())

                    // 徽章
                    Text("徽章").font(.headline)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        BadgeCard(title: "感謝戰士",
                                  desc: "完成 5 天任務",
                                  earned: days >= 5,
                                  emoji: "🙇‍♂️")
                        BadgeCard(title: "訂購冒險家",
                                  desc: "完成 10 天任務",
                                  earned: days >= 10,
                                  emoji: "🧋")
                        BadgeCard(title: "社會核心挑戰者",
                                  desc: "地獄級相關任務 3 次",
                                  earned: hell >= 3,
                                  emoji: "💣")
                    }

                    // 頭銜
                    Text("頭銜").font(.headline).padding(.top, 8)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        TitleCard(title: "感謝戰士")
                        TitleCard(title: "訂購冒險家")
                        TitleCard(title: "社會核心挑戰者")
                    }

                    Text("選擇一個頭銜以在蕉流區快顯示，讓所有人都知道您的社會焦慮戰果成就！")
                        .font(.footnote)
                        .foregroundColor(DS.textSecondary)
                        .padding(.top, 6)
                }
                .padding()
            }
            .background(DS.bg)
            .navigationTitle("成就")
        }
    }
}

private struct BadgeCard: View {
    let title: String
    let desc: String
    let earned: Bool
    let emoji: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.15))
                Text(emoji).font(.system(size: 28))
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.bold())
                Text(desc).font(.caption).foregroundColor(.secondary)
                Text(earned ? "已解鎖" : "未解鎖")
                    .font(.caption2.bold())
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background((earned ? Color.green : Color.gray).opacity(0.25))
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.15))
        )
    }
}

private struct TitleCard: View {
    let title: String
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0.15))
                Image(systemName: "rosette")
            }
            .frame(width: 44, height: 44)
            Text(title).font(.subheadline)
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.15))
        )
    }
}
