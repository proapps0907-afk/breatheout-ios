import StoreKit
import SwiftUI

// ─── Purchase Manager (StoreKit 2) ───────────────────────────────────────────
@MainActor
final class PurchaseManager: ObservableObject {
  static let shared = PurchaseManager()

  // ── Product IDs (must match App Store Connect exactly) ─────────────────────
  static let monthlyID = "com.proapps.breatheOut.premium.monthly"
  static let annualID  = "com.proapps.breatheOut.premium.annual"
  static let allIDs    = [monthlyID, annualID]

  // ── State ──────────────────────────────────────────────────────────────────
  @Published var products: [Product] = []
  @Published var isLoading = false
  @Published var purchaseError: String? = nil

  private var transactionTask: Task<Void, Never>?

  // ── Init ───────────────────────────────────────────────────────────────────
  init() {
    transactionTask = Task { await listenForTransactions() }
    Task { await loadProducts() }
  }

  deinit { transactionTask?.cancel() }

  // ── Load Products ──────────────────────────────────────────────────────────
  func loadProducts() async {
    isLoading = true
    do {
      let fetched = try await Product.products(for: PurchaseManager.allIDs)
      products = fetched.sorted { $0.price < $1.price }
    } catch {
      purchaseError = error.localizedDescription
    }
    isLoading = false
  }

  // ── Purchase ───────────────────────────────────────────────────────────────
  /// Returns true if the purchase was completed successfully.
  func purchase(_ product: Product) async throws -> Bool {
    let result = try await product.purchase()
    switch result {
    case .success(let verification):
      let transaction = try checkVerified(verification)
      await transaction.finish()
      await refreshSubscriptionStatus()
      return true
    case .userCancelled:
      return false
    case .pending:
      return false
    @unknown default:
      return false
    }
  }

  // ── Restore ────────────────────────────────────────────────────────────────
  func restore() async throws {
    try await AppStore.sync()
    await refreshSubscriptionStatus()
  }

  // ── Subscription Status ────────────────────────────────────────────────────
  /// Checks current entitlements and updates Store.shared.isPremium.
  func refreshSubscriptionStatus() async {
    var hasActive = false
    for await result in Transaction.currentEntitlements {
      if case .verified(let tx) = result,
         tx.productType == .autoRenewable,
         tx.revocationDate == nil {
        hasActive = true
      }
    }
    Store.shared.setPremium(hasActive)
  }

  // ── Convenience Accessors ──────────────────────────────────────────────────
  var monthlyProduct: Product? { products.first { $0.id == PurchaseManager.monthlyID } }
  var annualProduct:  Product? { products.first { $0.id == PurchaseManager.annualID  } }

  // ── Helpers ────────────────────────────────────────────────────────────────
  private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
    switch result {
    case .unverified(_, let error): throw error
    case .verified(let value):      return value
    }
  }

  private func listenForTransactions() async {
    for await result in Transaction.updates {
      if case .verified(let tx) = result {
        await tx.finish()
        await refreshSubscriptionStatus()
      }
    }
  }
}
