//設定頁，可調整偏好（如 Onboarding 顯示、頭貼）

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @EnvironmentObject var app: AppState
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                // 頭貼
                Section(header: Text("頭貼")) {
                    HStack(spacing: 16) {
                        AvatarView(data: app.avatarImageData)
                            .frame(width: 56, height: 56)

                        PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
                            Text("更換頭貼")
                        }
                        .onChange(of: pickerItem) { _, newValue in
                            Task {
                                guard let item = newValue,
                                      let data = try? await item.loadTransferable(type: Data.self) else { return }
                                app.avatarImageData = data
                            }
                        }

                        Spacer()

                        if app.avatarImageData != nil {
                            Button(role: .destructive) {
                                app.avatarImageData = nil
                            } label: { Text("移除") }
                        }
                    }
                }

                // 引導頁設定（保留）
                Section(header: Text("引導頁")) {
                    Toggle(isOn: $app.showOnboardingEveryLaunch) {
                        VStack(alignment: .leading) {
                            Text("每次開啟顯示引導頁")
                            Text("預設開啟，每天幫你加一點社交勇氣 buff 🪄")
                                .font(.caption).foregroundColor(.secondary)
                        }
                    }
                }

                // 關於
                Section(header: Text("關於")) {
                    LabeledContent("版本", value: "banana 1.0")
                    LabeledContent("主題", value: "治癒 + 搞笑 + 社恐實用")
                }
            }
            .navigationTitle("設定")
        }
    }
}

private struct AvatarView: View {
    let data: Data?
    var body: some View {
        Group {
            if let data, let ui = UIImage(data: data) {
                Image(uiImage: ui).resizable().scaledToFill()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable().scaledToFit()
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(6)
            }
        }
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.secondary.opacity(0.2)))
    }
}
