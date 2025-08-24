//定義共用顏色、字體、按鈕與卡片樣式

import SwiftUI

// MARK: - Design System

enum DS {
    // Colors（可依 Figma 再微調）
    static let bg = Color(UIColor.systemGray6)
    static let card = Color.white
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    static let primaryBlue = Color(red: 0.10, green: 0.49, blue: 0.97)
    static let primaryBlueLight = Color(red: 0.55, green: 0.76, blue: 1.0)

    // Corner & Shadow
    static let cornerM: CGFloat = 12
    static let cornerL: CGFloat = 18
    static let cornerXL: CGFloat = 24

    static let shadow = ShadowStyle(radius: 8, y: 3, opacity: 0.12)
    struct ShadowStyle { let radius: CGFloat; let y: CGFloat; let opacity: Double }
}

// MARK: - Common Components

extension View {
    /// 卡片外觀
    func dsCard() -> some View {
        self
            .background(DS.card)
            .clipShape(RoundedRectangle(cornerRadius: DS.cornerXL, style: .continuous))
            .shadow(color: .black.opacity(DS.shadow.opacity),
                    radius: DS.shadow.radius, x: 0, y: DS.shadow.y)
    }

    /// 單色膠囊（用在 Difficulty 等）
    func dsPill(_ color: Color) -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.12))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

// MARK: - Buttons

/// 三種按鈕大小
enum ButtonSize { case small, medium, large }

extension View {
    /// 主要按鈕（藍底白字）支援大小
    func primaryButton(size: ButtonSize = .large) -> some View {
        self
            .font(fontFor(size))
            .padding(.vertical, paddingV(size))
            .padding(.horizontal, paddingH(size))
            .frame(minHeight: height(size))
            .frame(maxWidth: .infinity)
            .background(DS.primaryBlue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: DS.cornerM, style: .continuous))
    }

    /// 次要按鈕（白底藍字，有邊框）
    func secondaryButton(size: ButtonSize = .large) -> some View {
        self
            .font(fontFor(size))
            .padding(.vertical, paddingV(size))
            .padding(.horizontal, paddingH(size))
            .frame(minHeight: height(size))
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(DS.primaryBlue)
            .overlay(
                RoundedRectangle(cornerRadius: DS.cornerM, style: .continuous)
                    .stroke(DS.primaryBlue.opacity(0.25), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: DS.cornerM, style: .continuous))
    }
}

// MARK: - Private helpers

private func fontFor(_ size: ButtonSize) -> Font {
    switch size {
    case .small:  return .caption.bold()
    case .medium: return .subheadline.bold()
    case .large:  return .headline.bold()
    }
}
private func paddingV(_ size: ButtonSize) -> CGFloat {
    switch size {
    case .small:  return 6
    case .medium: return 8
    case .large:  return 12
    }
}
private func paddingH(_ size: ButtonSize) -> CGFloat {
    switch size {
    case .small:  return 12
    case .medium: return 20
    case .large:  return 28
    }
}
private func height(_ size: ButtonSize) -> CGFloat {
    switch size {
    case .small:  return 28
    case .medium: return 36
    case .large:  return 44
    }
}
