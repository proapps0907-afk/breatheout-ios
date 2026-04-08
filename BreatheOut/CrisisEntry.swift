import Foundation

// ─── Crisis Entry Model ──────────────────────────────────────────────────────
struct CrisisEntry: Codable, Identifiable {
  let id: String
  let timestamp: Date
  let trigger: String
  let toolUsed: String
  let intensityBefore: Int
  let intensityAfter: Int?
  let notes: String?

  init(
    id: String = UUID().uuidString,
    timestamp: Date = Date(),
    trigger: String,
    toolUsed: String,
    intensityBefore: Int,
    intensityAfter: Int? = nil,
    notes: String? = nil
  ) {
    self.id = id
    self.timestamp = timestamp
    self.trigger = trigger
    self.toolUsed = toolUsed
    self.intensityBefore = intensityBefore
    self.intensityAfter = intensityAfter
    self.notes = notes
  }
}

// ─── Storage Manager ─────────────────────────────────────────────────────────
final class StorageManager {
  static let shared = StorageManager()

  private let userDefaults = UserDefaults.standard
  private let entriesKey = "crisis_entries"
  private let onboardingKey = "onboarding_done"
  private let premiumKey = "is_premium"
  private let firstUseKey = "first_use_done"
  private let paywallShownKey = "paywall_shown"
  private let languageKey = "is_spanish"

  // ── Language ───────────────────────────────────────────────────────────────
  var isSpanish: Bool {
    get { userDefaults.bool(forKey: languageKey) }
    set {
      userDefaults.set(newValue, forKey: languageKey)
      L10n.isSpanish = newValue
    }
  }

  // ── Flags ──────────────────────────────────────────────────────────────────
  var isOnboardingDone: Bool {
    get { userDefaults.bool(forKey: onboardingKey) }
    set { userDefaults.set(newValue, forKey: onboardingKey) }
  }

  var isPremium: Bool {
    get { userDefaults.bool(forKey: premiumKey) }
    set { userDefaults.set(newValue, forKey: premiumKey) }
  }

  var isFirstUseDone: Bool {
    get { userDefaults.bool(forKey: firstUseKey) }
    set { userDefaults.set(newValue, forKey: firstUseKey) }
  }

  var isPaywallShown: Bool {
    get { userDefaults.bool(forKey: paywallShownKey) }
    set { userDefaults.set(newValue, forKey: paywallShownKey) }
  }

  // ── CRUD Entries ───────────────────────────────────────────────────────────
  var allEntries: [CrisisEntry] {
    get {
      guard let data = userDefaults.data(forKey: entriesKey),
            let entries = try? JSONDecoder().decode([CrisisEntry].self, from: data)
      else {
        return []
      }
      return Array(entries.reversed())
    }
  }

  func addEntry(_ entry: CrisisEntry) {
    var entries = Array(allEntries.reversed())
    entries.append(entry)
    saveEntries(entries)
  }

  func deleteEntry(at index: Int) {
    var entries = Array(allEntries.reversed())
    guard index < entries.count else { return }
    entries.remove(at: index)
    saveEntries(entries)
  }

  func clearAllEntries() {
    userDefaults.removeObject(forKey: entriesKey)
  }

  private func saveEntries(_ entries: [CrisisEntry]) {
    if let data = try? JSONEncoder().encode(entries) {
      userDefaults.set(data, forKey: entriesKey)
    }
  }

  // ── Analytics ──────────────────────────────────────────────────────────────
  func triggerCounts() -> [String: Int] {
    var counts: [String: Int] = [:]
    for entry in allEntries {
      counts[entry.trigger] = (counts[entry.trigger] ?? 0) + 1
    }
    return counts
  }

  func toolCounts() -> [String: Int] {
    var counts: [String: Int] = [:]
    for entry in allEntries {
      counts[entry.toolUsed] = (counts[entry.toolUsed] ?? 0) + 1
    }
    return counts
  }

  func last30Days() -> [CrisisEntry] {
    let cutoff = Date().addingTimeInterval(-30 * 24 * 60 * 60)
    return allEntries.filter { $0.timestamp > cutoff }
  }
}
