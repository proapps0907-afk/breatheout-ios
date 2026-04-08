import SwiftUI
import Combine

// ─── Main Store (ViewModel) ──────────────────────────────────────────────────
@MainActor
final class Store: ObservableObject {
  static let shared = Store()

  private let storage = StorageManager.shared
  private var cancellables = Set<AnyCancellable>()

  // ── Published State ────────────────────────────────────────────────────────
  @Published var isOnboardingDone: Bool = false
  @Published var isPremium: Bool = false
  @Published var isFirstUseDone: Bool = false
  @Published var isPaywallShown: Bool = false
  @Published var isSpanish: Bool = false
  @Published var entries: [CrisisEntry] = []
  @Published var currentEntry: CrisisEntry? = nil

  // ── Init ───────────────────────────────────────────────────────────────────
  init() {
    loadState()
  }

  func loadState() {
    isOnboardingDone = storage.isOnboardingDone
    isPremium = storage.isPremium
    isFirstUseDone = storage.isFirstUseDone
    isPaywallShown = storage.isPaywallShown
    isSpanish = storage.isSpanish
    entries = storage.allEntries
    L10n.isSpanish = isSpanish
  }

  // ── Onboarding ─────────────────────────────────────────────────────────────
  func completeOnboarding() {
    storage.isOnboardingDone = true
    isOnboardingDone = true
  }

  // ── Language ───────────────────────────────────────────────────────────────
  func toggleLanguage() {
    isSpanish.toggle()
    storage.isSpanish = isSpanish
    L10n.isSpanish = isSpanish
  }

  // ── Premium ────────────────────────────────────────────────────────────────
  func setPremium(_ value: Bool) {
    storage.isPremium = value
    isPremium = value
  }

  func markPaywallShown() {
    storage.isPaywallShown = true
    isPaywallShown = true
  }

  // ── Entries ────────────────────────────────────────────────────────────────
  func addEntry(_ entry: CrisisEntry) {
    storage.addEntry(entry)
    entries = storage.allEntries
  }

  func deleteEntry(at index: Int) {
    storage.deleteEntry(at: index)
    entries = storage.allEntries
  }

  func clearAllEntries() {
    storage.clearAllEntries()
    entries = []
  }

  func setCurrentEntry(_ entry: CrisisEntry?) {
    currentEntry = entry
  }

  // ── Analytics ──────────────────────────────────────────────────────────────
  func getTriggerCounts() -> [String: Int] {
    return storage.triggerCounts()
  }

  func getToolCounts() -> [String: Int] {
    return storage.toolCounts()
  }

  func getLast30Days() -> [CrisisEntry] {
    return storage.last30Days()
  }
}
