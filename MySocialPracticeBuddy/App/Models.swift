//定義 Challenge、Post、Mood、Difficulty 等資料模型

import SwiftUI

enum Difficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case advanced = "Advanced"
    case hell = "Hell Mode"
}

struct Challenge: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let tip: String
    let difficulty: Difficulty
}

enum Mood: Int, Codable, CaseIterable, Identifiable {
    case awkward = 0, ok = 1, brave = 2
    var id: Int { rawValue }
    var label: String {
        switch self {
        case .awkward: return "😭 超尷尬"
        case .ok:      return "😐 還行啦"
        case .brave:   return "🤩 我超勇！"
        }
    }
}

struct Post: Identifiable, Codable {
    let id: UUID
    let dateKey: String // yyyy-MM-dd
    let text: String
    var bananas: Int
    let mood: Mood
//    let displayName: String
    // 新增：作者（本機）識別，用來判斷是否顯示頭貼
    var authorId: String? = nil
        // 你之前顯示用的暱稱仍保留（現在 UI 固定顯示「匿名蕉友」，但不刪欄位以免影響舊資料）
    let displayName: String
}

