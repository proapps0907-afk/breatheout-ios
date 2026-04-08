import SwiftUI
import UIKit

// ─── Haptics ─────────────────────────────────────────────────────────────────
struct Haptics {
  static func light() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
  }

  static func medium() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
  }

  static func heavy() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
  }

  static func success() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
  }

  static func error() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
  }
}

// ─── Date Formatter ──────────────────────────────────────────────────────────
extension Date {
  var relativeString: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    return formatter.localizedString(for: self, relativeTo: Date())
  }

  var shortString: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter.string(from: self)
  }
}

// ─── View Extensions ─────────────────────────────────────────────────────────
extension View {
  func `class`<C: AnyObject>(_ type: C.Type) -> C? {
    return nil
  }
}

