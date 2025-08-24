//管理全域狀態（任務、社群、Onboarding、成就統計）

//import SwiftUI
//
//final class AppState: ObservableObject {
//    // MARK: - Onboarding
//    @AppStorage("showOnboardingEveryLaunch") var showOnboardingEveryLaunch: Bool = true
//    @Published var showOnboardingNow: Bool = false
//
//    // MARK: - User Profile（本機）
//    /// 本機使用者 ID（用來標示自己的貼文）
//    @AppStorage("currentUserId") var currentUserId: String = ""
//    /// 頭貼影像資料（JPEG/PNG Data）
//    @AppStorage("avatarImageData") var avatarImageData: Data?
//
//    // MARK: - 社群資料（本地持久化）
//    @Published var posts: [Post] = [] { didSet { savePosts() } }
//    private let postsKey = "community_posts_v1"
//
//    init() {
//        if currentUserId.isEmpty { currentUserId = UUID().uuidString } // 首次安裝產生
//        loadPosts()
//    }
//
//    func presentOnboardingOnLaunch() {
//        if showOnboardingEveryLaunch { showOnboardingNow = true }
//    }
//
//    // MARK: - 持久化
//    private func loadPosts() {
//        if let data = UserDefaults.standard.data(forKey: postsKey),
//           let decoded = try? JSONDecoder().decode([Post].self, from: data) {
//            posts = decoded
//        }
//    }
//    private func savePosts() {
//        if let data = try? JSONEncoder().encode(posts) {
//            UserDefaults.standard.set(data, forKey: postsKey)
//        }
//    }
//
//    // MARK: - 日期工具
//    func todayKey(date: Date = Date()) -> String {
//        var cal = Calendar(identifier: .gregorian); cal.timeZone = .current
//        let f = DateFormatter()
//        f.calendar = cal; f.locale = Locale(identifier: "zh_TW"); f.timeZone = .current
//        f.dateFormat = "yyyy-MM-dd"
//        return f.string(from: date)
//    }
//
//    /// 一天一個穩定種子
//    private func daySeed(_ date: Date = Date()) -> Int {
//        var cal = Calendar(identifier: .gregorian); cal.timeZone = .current
//        let start = cal.startOfDay(for: date)
//        return Int(start.timeIntervalSince1970 / 86_400)
//    }
//
//    // MARK: - 每日任務（你的清單原樣）
//    let challengePool: [Challenge] = [
//        // 初級
//        .init(id: .init(), title: "跟店員說「謝謝」", tip: "放心，不會因此被逮捕 🫡", difficulty: .beginner),
//        .init(id: .init(), title: "對熟悉的同學/同事點頭微笑", tip: "0.5 秒也算", difficulty: .beginner),
//        .init(id: .init(), title: "在群組打招呼", tip: "只說嗨也可以", difficulty: .beginner),
//        .init(id: .init(), title: "向外送員說「辛苦了」", tip: "騎士們值得", difficulty: .beginner),
//        .init(id: .init(), title: "看到認識的人打招呼（揮手或點頭）", tip: "像 Wi‑Fi 連線一下", difficulty: .beginner),
//        .init(id: .init(), title: "結帳主動說「袋子不用」", tip: "省 2 元也省地球", difficulty: .beginner),
//        .init(id: .init(), title: "問櫃台「洗手間在哪裡？」", tip: "三詞出關：洗手間在哪", difficulty: .beginner),
//        .init(id: .init(), title: "真心稱讚朋友一句", tip: "中性、具體、不油膩", difficulty: .beginner),
//        .init(id: .init(), title: "課後說「謝謝老師」", tip: "小聲也算數", difficulty: .beginner),
//        .init(id: .init(), title: "私訊熟人「最近好嗎？」", tip: "五個字就很棒", difficulty: .beginner),
//        .init(id: .init(), title: "扶門 2 秒讓後面的人先過", tip: "國際禮儀達成", difficulty: .beginner),
//        .init(id: .init(), title: "確認餐點客製（少糖/去冰）", tip: "訓練講出需求", difficulty: .beginner),
//
//        // 中級
//        .init(id: .init(), title: "問同學/同事一個今天的小問題", tip: "拋出一句：這題你怎麼做？", difficulty: .advanced),
//        .init(id: .init(), title: "請店員推薦一款飲料", tip: "把選擇困難丟給專家", difficulty: .advanced),
//        .init(id: .init(), title: "問路（而不是問 Google）", tip: "一句就好：請問 XX 怎麼走？", difficulty: .advanced),
////        .init(id: .init(), title: "請教助教/學長姐 1 個概念", tip: "限定 1 分鐘，不拖人時間", difficulty: .advanced),
//        .init(id: .init(), title: "打給朋友聊 1 分鐘", tip: "先寫好 2 句開場白", difficulty: .advanced),
//        .init(id: .init(), title: "邀同學/同事一起午餐", tip: "被拒絕也沒關係！", difficulty: .advanced),
//        .init(id: .init(), title: "詢問是否有學生/會員優惠", tip: "勇敢幫錢包發聲", difficulty: .advanced),
//        .init(id: .init(), title: "和鄰座同事/同學閒聊一句", tip: "勇敢開頭說第一句話！", difficulty: .advanced),
//
//        // 高級
//        .init(id: .init(), title: "打電話訂便當/飲料", tip: "30 秒話術：你好、數量、口味、取餐時間、謝謝", difficulty: .hell),
//        .init(id: .init(), title: "課堂/會議中發言 1 次", tip: "問問題也算發言", difficulty: .hell),
//        .init(id: .init(), title: "做 1 分鐘口頭報告（無投影片）", tip: "開場-重點-收尾 三句結構", difficulty: .hell),
//    ]
//
//    func todayChallenge(date: Date = Date()) -> Challenge {
//        let seed = daySeed(date)
//        let count = max(1, challengePool.count)
//        let idx = (seed % count + count) % count
//        return challengePool[idx]
//    }
//
//    // MARK: - 社群
//    func todayPosts() -> [Post] {
//        posts.filter { $0.dateKey == todayKey() }.sorted { $0.bananas > $1.bananas }
//    }
//
//    func addPost(text: String, mood: Mood) {
//        posts.append(.init(
//            id: .init(),
//            dateKey: todayKey(),
//            text: text,
//            bananas: 0,
//            mood: mood,
//            authorId: currentUserId,                // ✅ 記錄作者
//            displayName: "匿名蕉友"                  // 現在 UI 固定顯示這個
//        ))
//    }
//
//    func giveBanana(to post: Post) {
//        if let i = posts.firstIndex(where: { $0.id == post.id }) { posts[i].bananas += 1 }
//    }
//}





import SwiftUI

// MARK: - 全域狀態
final class AppState: ObservableObject {

    // Onboarding
    @AppStorage("showOnboardingEveryLaunch") var showOnboardingEveryLaunch: Bool = true
    @Published var showOnboardingNow: Bool = false

    // 使用者（頭貼 / ID）
    private let avatarKey = "avatar_image_v1"
    private let userIdKey = "current_user_id_v1"
    @Published var avatarImageData: Data? {
        didSet { UserDefaults.standard.set(avatarImageData, forKey: avatarKey) }
    }
    @AppStorage("current_user_id_v1") var currentUserId: String = ""

    // 社群資料（本地持久化）
    @Published var posts: [Post] = [] { didSet { savePosts() } }
    private let postsKey = "community_posts_v1"

    // 任務池
    let challengePool: [Challenge] = [
        // 初級
        .init(id: .init(), title: "跟店員說「謝謝」", tip: "放心，不會因此被逮捕 🫡", difficulty: .beginner),
        .init(id: .init(), title: "對熟悉的同學/同事點頭微笑", tip: "0.5 秒也算", difficulty: .beginner),
        .init(id: .init(), title: "在群組打招呼", tip: "只說嗨也可以", difficulty: .beginner),
        .init(id: .init(), title: "向外送員說「辛苦了」", tip: "騎士們值得", difficulty: .beginner),
        .init(id: .init(), title: "看到認識的人打招呼（揮手或點頭）", tip: "像 Wi‑Fi 連線一下", difficulty: .beginner),
        .init(id: .init(), title: "結帳主動說「袋子不用」", tip: "省 2 元也省地球", difficulty: .beginner),
        .init(id: .init(), title: "問櫃台「洗手間在哪裡？」", tip: "三詞出關：洗手間在哪", difficulty: .beginner),
        .init(id: .init(), title: "真心稱讚朋友一句", tip: "中性、具體、不油膩", difficulty: .beginner),
        .init(id: .init(), title: "課後說「謝謝老師」", tip: "小聲也算數", difficulty: .beginner),
        .init(id: .init(), title: "私訊熟人「最近好嗎？」", tip: "五個字就很棒", difficulty: .beginner),
        .init(id: .init(), title: "扶門 2 秒讓後面的人先過", tip: "國際禮儀達成", difficulty: .beginner),
        .init(id: .init(), title: "確認餐點客製（少糖/去冰）", tip: "訓練講出需求", difficulty: .beginner),

        // 中級
        .init(id: .init(), title: "問同學/同事一個今天的小問題", tip: "拋出一句：這題你怎麼做？", difficulty: .advanced),
        .init(id: .init(), title: "請店員推薦一款飲料", tip: "把選擇困難丟給專家", difficulty: .advanced),
        .init(id: .init(), title: "問路（而不是問 Google）", tip: "一句就好：請問 XX 怎麼走？", difficulty: .advanced),
        .init(id: .init(), title: "請教助教/學長姐 1 個概念", tip: "限定 1 分鐘，不拖人時間", difficulty: .advanced),
        .init(id: .init(), title: "打給朋友聊 1 分鐘", tip: "先寫好 2 句開場白", difficulty: .advanced),
        .init(id: .init(), title: "邀同學/同事一起午餐", tip: "被拒也當完成", difficulty: .advanced),
        .init(id: .init(), title: "在社群留 1 則正向留言", tip: "比讚更有溫度", difficulty: .advanced),
        .init(id: .init(), title: "詢問是否有學生/會員優惠", tip: "勇敢幫錢包發聲", difficulty: .advanced),
        .init(id: .init(), title: "和鄰座閒聊一句天氣/冷氣", tip: "一句就收工", difficulty: .advanced),

        // 地獄級
        .init(id: .init(), title: "打電話訂便當/飲料", tip: "30 秒話術：你好、數量、口味、取餐時間、謝謝", difficulty: .hell),
        .init(id: .init(), title: "課堂/會議中發言 1 次", tip: "問問題也算發言", difficulty: .hell),
        .init(id: .init(), title: "做 1 分鐘口頭報告（無投影片）", tip: "開場-重點-收尾 三句結構", difficulty: .hell),
        .init(id: .init(), title: "與陌生人完成 1 次協調（借位/排隊）", tip: "不好意思→需求→謝謝", difficulty: .hell),
        .init(id: .init(), title: "當面稱讚陌生人中性特點（衣著/髮型）", tip: "一句且不跟蹤，完成即收工", difficulty: .hell)
    ]

    // MARK: - 生命週期 / 初始資料
    init() {
        // 使用者 ID（若無則建立一次）
        if currentUserId.isEmpty {
            currentUserId = UUID().uuidString
        }
        // 頭貼載入
        avatarImageData = UserDefaults.standard.data(forKey: avatarKey)

        // 載入 posts；若完全沒有，塞三則示範資料
        loadPosts()
        if posts.isEmpty {
            posts = demoPostsForToday()
            savePosts()
        }
    }

    // MARK: - Onboarding 顯示
    func presentOnboardingOnLaunch() {
        if showOnboardingEveryLaunch { showOnboardingNow = true }
    }

    // MARK: - 日期 / 今日任務
    func todayKey(date: Date = Date()) -> String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    /// 依「日期字串 hash」每天固定一題，隔天自動換
    func todayChallenge() -> Challenge {
        let key = todayKey() + "|v1"              // 小小加鹽避免未來改版衝突
        let hash = abs(key.hashValue)
        let idx = hash % max(1, challengePool.count)
        return challengePool[idx]
    }

    // MARK: - 社群操作
    func todayPosts() -> [Post] {
        posts
            .filter { $0.dateKey == todayKey() }
            .sorted { $0.bananas > $1.bananas }
    }

    func addPost(text: String, mood: Mood) {
        posts.append(
            .init(id: .init(),
                  dateKey: todayKey(),
                  text: text,
                  bananas: 0,
                  mood: mood,
                  displayName: "匿名蕉友")
        )
    }

    func giveBanana(to post: Post) {
        if let i = posts.firstIndex(where: { $0.id == post.id }) {
            posts[i].bananas += 1
        }
    }

    // MARK: - 成就統計
    func totalDaysCompleted() -> Int {
        Set(posts.map { $0.dateKey }).count
    }
    func hellModeCount() -> Int {
        posts.filter {
            $0.text.contains("電話") || $0.text.contains("地獄") || $0.text.contains("核爆")
        }.count
    }

    // MARK: - 持久化
    private func loadPosts() {
        if let data = UserDefaults.standard.data(forKey: postsKey),
           let decoded = try? JSONDecoder().decode([Post].self, from: data) {
            posts = decoded
        }
    }
    private func savePosts() {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: postsKey)
        }
    }

    // MARK: - Demo 資料（只在第一次啟動時塞入）
    private func demoPostsForToday() -> [Post] {
        let k = todayKey()
        return [
            Post(id: .init(), dateKey: k,
                 text: "We did it !",
                 bananas: 21, mood: .brave,   displayName: "匿名蕉友"),
            Post(id: .init(), dateKey: k,
                 text: "好像沒有這麼可怕耶！！！",
                 bananas: 16, mood: .ok,      displayName: "匿名蕉友"),
            Post(id: .init(), dateKey: k,
                 text: "他不理我，好尷尬嗚嗚",
                 bananas: 6,  mood: .awkward, displayName: "匿名蕉友")
        ]
    }
}
