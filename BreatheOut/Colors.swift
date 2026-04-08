import SwiftUI

// ─── Color Tokens ─────────────────────────────────────────────────────────────
struct AppColors {
  static let background      = Color(hex: "0D0D1A")
  static let surface         = Color(hex: "1A1A2E")
  static let surfaceCard     = Color(hex: "22223A")
  static let primary         = Color(hex: "B8A9E3")
  static let primaryDeep     = Color(hex: "8B7EC8")
  static let primaryGlow     = Color(hex: "6B5EA8")
  static let accent          = Color(hex: "7FB3D3")
  static let accentSoft      = Color(hex: "5A9BBF")
  static let textPrimary     = Color(hex: "E8E8F0")
  static let textSecondary   = Color(hex: "AAABC0")
  static let textMuted       = Color(hex: "6B6B8A")
  static let sos             = Color(hex: "E87B7B")
  static let sosDark         = Color(hex: "C45A5A")
  static let success         = Color(hex: "7BC8A4")
  static let successDark     = Color(hex: "5AAA84")
  static let warning         = Color(hex: "E8C87B")
  static let divider         = Color(hex: "2A2A45")

  // Gradients
  static let primaryGradient = LinearGradient(
    colors: [primary, primaryDeep],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let backgroundGradient = LinearGradient(
    colors: [Color(hex: "0D0D1A"), Color(hex: "12122A")],
    startPoint: .top,
    endPoint: .bottom
  )

  static let accentGradient = LinearGradient(
    colors: [accent, accentSoft],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}

// ─── Color Extension ──────────────────────────────────────────────────────────
extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
