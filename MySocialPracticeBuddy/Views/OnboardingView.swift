//新手引導頁，介紹 App 用法與特色

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @AppStorage("showOnboardingEveryLaunch") private var showOnboardingEveryLaunch: Bool = true
    @State private var page = 0

    var body: some View {
        VStack {
            TabView(selection: $page) {
                OnboardPage(title: "歡迎使用社交訓練蕉流器！",
                            subtitle: "每天一個社交小挑戰，逐步升級為社交戰士 ✨",
                            imageName: "onboard1").tag(0)
                OnboardPage(title: "每天一個社交挑戰",
                            subtitle: "從初學者到地獄模式，跨出的任何一小步都是成長的一大步 💪",
                            imageName: "onboard2").tag(1)
                OnboardPage(title: "分享社交心得，收穫蕉蕉 🍌",
                            subtitle: "這裡沒有酸民，只有跟你一起練習改善社恐的夥伴",
                            imageName: "onboard3").tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            Button {
                if page < 2 { withAnimation { page += 1 } }
                else { showOnboarding = false }
            } label: {
                Text(page < 2 ? "下一步" : "開始")
                    .primaryButton()
                    .padding(.horizontal)
            }

            .padding(.bottom, 20)
        }
        .background(DS.bg)
        .overlay(alignment: .topTrailing) {
            HStack(spacing: 4) {
                Button { showOnboarding = false } label: {
                    Text("跳過").font(.subheadline).foregroundColor(.secondary)
                }
                Text("・").foregroundColor(.secondary)
                Button {
                    showOnboardingEveryLaunch = false
                    showOnboarding = false
                } label: {
                    Text("不再顯示").font(.subheadline).foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 10)
        }
    }
}

struct OnboardPage: View {
    let title: String; let subtitle: String; let imageName: String
    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 10)
            Text(title).font(.title3.bold()).multilineTextAlignment(.center)
            Text(subtitle).font(.footnote).foregroundColor(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            Image(imageName)
                .resizable().scaledToFit().frame(maxHeight: 240)
                .clipShape(RoundedRectangle(cornerRadius: DS.cornerL))
                .padding(.horizontal, 20)
            Spacer()
        }
    }
}

