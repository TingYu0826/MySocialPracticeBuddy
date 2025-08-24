//挑戰詳情頁，輸入心得並完成任務

import SwiftUI

struct ChallengeDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var app: AppState
    let challenge: Challenge

    @State private var note = ""
    @State private var moodValue: Double = 50

    private var mood: Mood {
        switch moodValue {
        case 0..<34: return .awkward
        case 34..<67: return .ok
        default: return .brave
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    Text("今日的挑戰").font(.title3.bold())

                    // 任務卡：完全吃 challenge
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "text.bubble")
                                .foregroundColor(DS.primaryBlue)
                            Text("任務內容").font(.subheadline.bold())
                            Spacer()
                            DifficultyChip(difficulty: challenge.difficulty)
                        }
                        // 這兩行就是關鍵：不再硬寫文案
                        Text(challenge.title)
                            .font(.subheadline.bold())
                        Text(challenge.tip)
                            .font(.subheadline)
                            .foregroundColor(DS.textSecondary)
                    }
                    .padding()
                    .background(DS.bg)
                    .clipShape(RoundedRectangle(cornerRadius: DS.cornerL))

                    // 輸入與滑桿（原樣）
                    VStack(alignment: .leading, spacing: 8) {
                        Text("分享您的社交大無畏冒險想法…（例如：我的聲音顫抖，但我做到了）")
                            .font(.footnote).foregroundColor(DS.textSecondary)

                        TextEditor(text: $note)
                            .frame(minHeight: 140)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: DS.cornerL)
                                    .stroke(DS.textSecondary.opacity(0.2), lineWidth: 1)
                            )
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: DS.cornerL))
                    }

                    HStack { Text("😖 超尷尬—"); Spacer()
                        Text("—😐 還行啦—"); Spacer()
                        Text("—🤩 我超勇！") }
                    .font(.caption)

                    HStack {
                        Slider(value: $moodValue, in: 0...100, step: 1)
                        Text("\(Int(moodValue))")
                            .font(.callout.monospacedDigit())
                            .frame(width: 36)
                    }

                    Button {
                        let t = note.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !t.isEmpty else { return }
                        app.addPost(text: t, mood: mood)
                        dismiss()
                    } label: {
                        Text("任務完成 ✅").primaryButton()
                    }
                    .padding(.top, 4)
                }
                .padding()
            }
            .background(DS.bg)
            .navigationTitle("今日的挑戰：\(challenge.title)") // ← 這裡也一起動態化
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: { Image(systemName: "chevron.left") }
                }
            }
        }
    }
}

// 和首頁一致的難度膠囊（淺色 + 黑字）
private struct DifficultyChip: View {
    let difficulty: Difficulty
    var body: some View {
        Text(label)
            .font(.caption2.bold())
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.25))
            .foregroundColor(.black)
            .clipShape(Capsule())
    }
    private var label: String { switch difficulty {
        case .beginner: "初學者"; case .advanced: "進階"; case .hell: "地獄模式" } }
    private var color: Color { switch difficulty {
        case .beginner: .green; case .advanced: .orange; case .hell: .red } }
}
