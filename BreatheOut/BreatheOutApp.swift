import SwiftUI

@main
struct BreatheOutApp: App {
  @StateObject private var store = Store.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(store)
        .preferredColorScheme(.dark)
        .task {
          // Verify subscription status with Apple on every launch
          await PurchaseManager.shared.refreshSubscriptionStatus()
        }
    }
  }
}

// ─── Content View (Router) ───────────────────────────────────────────────────
struct ContentView: View {
  @EnvironmentObject var store: Store

  var body: some View {
    Group {
      if !store.isOnboardingDone {
        OnboardingView()
      } else {
        HomeView()
      }
    }
    .tint(AppColors.primary)
  }
}
