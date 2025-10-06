import SwiftUI

struct LiquidGlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 28
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.thinMaterial)
                    .glassBackgroundEffect()
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(LinearGradient(colors: [.white.opacity(0.4), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.2)
                    )
                    .shadow(color: Color.black.opacity(0.35), radius: 30, x: 0, y: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.35).gradient, lineWidth: 0.6)
                    .blendMode(.softLight)
            )
    }
}

extension View {
    func glassButtonStyle() -> some View {
        self
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule(style: .continuous)
                    .fill(.ultraThinMaterial)
                    .glassBackgroundEffect()
            )
    }
}
