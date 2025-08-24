//蕉流區社群，顯示貼文、心情與丟香蕉互動

import SwiftUI

struct CommunityView: View {
    @EnvironmentObject var app: AppState
    var posts: [Post] { app.todayPosts() }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("今日共有 \(posts.count) 位勇者完成挑戰，一起丟出 \(posts.reduce(0){$0+$1.bananas}) 根 🍌")
                        .font(.footnote).foregroundColor(.secondary)
                }
                Section(header: Text("今日心得")) {
                    ForEach(posts) { post in
                        CommunityRow(
                            post: post,
                            isMe: post.authorId == app.currentUserId,
                            myAvatarData: app.avatarImageData,
                            onBanana: { app.giveBanana(to: post) }
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("社交心得蕉流區")
            .background(DS.bg)
        }
    }
}

private struct CommunityRow: View {
    let post: Post
    let isMe: Bool
    let myAvatarData: Data?
    var onBanana: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 左側香蕉累計
            VStack(spacing: 6) {
                Text("🍌")
                Text("\(post.bananas)").font(.caption.monospacedDigit())
            }
            .frame(width: 28)

            // 頭像：自己的用頭貼，其他人用預設
            avatar
                .frame(width: 38, height: 38)

            VStack(alignment: .leading, spacing: 4) {
                // 固定匿名 + 粉色頭銜膠囊
                HStack(spacing: 6) {
                    Text("匿名蕉友").font(.subheadline.bold())
                    TitleChip(title: titleFor(post.mood))
                }

                Text(post.text).font(.body)

                HStack(spacing: 10) {
                    Text(formattedTime()).font(.caption).foregroundColor(.secondary)

                    // 心情膠囊（淺色 + 黑字）
                    MoodChip(mood: post.mood)

                    Spacer()

                    // ✅ 新：丟香蕉按鈕（含按壓變色 + 飄香蕉動畫）
                    BananaButton {
                        onBanana()
                    }
                }
            }
        }
        .padding(.vertical, 6)
        .buttonStyle(.plain) // 避免整行被當成可點擊高亮
    }

    private var avatar: some View {
        Group {
            if isMe, let d = myAvatarData, let ui = UIImage(data: d) {
                Image(uiImage: ui).resizable().scaledToFill()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable().scaledToFit()
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(2)
            }
        }
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.secondary.opacity(0.2)))
    }

    private func formattedTime() -> String {
        let f = DateFormatter(); f.dateFormat = "a H:mm"
        f.amSymbol = "上午"; f.pmSymbol = "下午"
        return f.string(from: Date())
    }

    private func titleFor(_ mood: Mood) -> String {
        switch mood {
        case .brave:   return "社會核心挑戰者"
        case .ok:      return "訂購冒險家"
        case .awkward: return "感謝戰士"
        }
    }
}

// 粉色頭銜膠囊
private struct TitleChip: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption2.bold())
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.pink.opacity(0.25))
            .foregroundColor(.black)
            .clipShape(Capsule())
    }
}

// 心情膠囊（淺色 + 黑字）
private struct MoodChip: View {
    let mood: Mood
    var body: some View {
        Text(text)
            .font(.caption2.bold())
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(bg.opacity(0.25))
            .foregroundColor(.black)
            .clipShape(Capsule())
    }
    private var text: String {
        switch mood {
        case .awkward: return "😭 超尷尬"
        case .ok:      return "😐 還行啦"
        case .brave:   return "🤩 我超勇"
        }
    }
    private var bg: Color {
        switch mood {
        case .awkward: return .red
        case .ok:      return .yellow
        case .brave:   return .green
        }
    }
}

//
// MARK: - 🍌 Banana Button with pop animation
//

private struct BananaFX: Identifiable, Equatable {
    let id = UUID()
    var xOffset: CGFloat
    var yOffset: CGFloat
    var scale: CGFloat
    var opacity: Double
}

private struct BananaButton: View {
    var onTap: () -> Void
    @State private var isPressed = false
    @State private var fxItems: [BananaFX] = []

    var body: some View {
        ZStack {
            // 按鈕本體
            Button(action: trigger) {
                HStack(spacing: 6) {
                    Text("🍌")
                    Text("+1")
                }
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isPressed ? Color.blue.opacity(0.5) : Color.blue.opacity(0.25))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            // 飄香蕉動畫（出現在按鈕上方）
            ZStack {
                ForEach(fxItems) { item in
                    Text("🍌")
                        .scaleEffect(item.scale)
                        .opacity(item.opacity)
                        .offset(x: item.xOffset, y: item.yOffset)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    private func trigger() {
        onTap()

        // 按壓閃一下
        withAnimation(.easeInOut(duration: 0.18)) { isPressed = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            withAnimation(.easeInOut(duration: 0.18)) { isPressed = false }
        }

        // 產生一根往上飄的香蕉
        spawnBanana()
    }

    private func spawnBanana() {
        // 初始狀態：在按鈕正上方附近（y 為 0），稍微隨機水平位移
        var item = BananaFX(
            xOffset: CGFloat.random(in: -2...2),
            yOffset: 0,
            scale: 0.8,
            opacity: 1.0
        )
        fxItems.append(item)

        // 目標狀態：向上飄 & 淡出
        let idx = fxItems.count - 1
        withAnimation(.easeOut(duration: 0.8)) {
            fxItems[idx].yOffset = -24   // 往上
            fxItems[idx].xOffset += CGFloat.random(in: -8...8)
            fxItems[idx].scale = 1.1
            fxItems[idx].opacity = 0.0
        }

        // 動畫結束移除
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.82) {
            if let first = fxItems.first {
                fxItems.removeAll { $0.id == first.id }
            }
        }
    }
}
