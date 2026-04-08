import SwiftUI
import StoreKit

// ─── Paywall View ─────────────────────────────────────────────────────────────
struct PaywallView: View {
  @EnvironmentObject var store: Store
  @Environment(\.dismiss) var dismiss
  @StateObject private var pm = PurchaseManager.shared

  @State private var selectedPlan = PurchaseManager.annualID
  @State private var isPurchasing = false
  @State private var showError = false
  @State private var errorMsg = ""

  private let features: [(String, String)] = [
    ("📊", "Monthly trend charts"),
    ("📄", "PDF export for your therapist"),
    ("🎨", "Custom breathing themes"),
    ("🔔", "Daily check-in reminders"),
  ]

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: "0D0D1A"), Color(hex: "12122A")],
        startPoint: .top, endPoint: .bottom
      ).ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          headerSection
          featuresSection.padding(.top, 28)
          plansSection.padding(.top, 24)
          ctaButton.padding(.top, 24)
          footerSection.padding(.top, 16).padding(.bottom, 48)
        }
        .padding(.horizontal, 24)
        .padding(.top, 48)
      }
    }
    .alert("Error", isPresented: $showError) {
      Button("OK") {}
    } message: {
      Text(errorMsg)
    }
    .task { await pm.loadProducts() }
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  private var headerSection: some View {
    VStack(spacing: 14) {
      Text("💜").font(.system(size: 56))

      Text(L10n.paywallTitle)
        .font(.system(size: 24, weight: .heavy))
        .foregroundColor(AppColors.textPrimary)
        .multilineTextAlignment(.center)

      Text(L10n.paywallSubtitle)
        .font(.system(size: 14))
        .foregroundColor(AppColors.textSecondary)
        .multilineTextAlignment(.center)
        .lineSpacing(3)
    }
  }

  // ── Features ───────────────────────────────────────────────────────────────
  private var featuresSection: some View {
    VStack(spacing: 10) {
      ForEach(features, id: \.0) { item in
        HStack(spacing: 14) {
          Text(item.0).font(.system(size: 20))
          Text(item.1)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(AppColors.textPrimary)
          Spacer()
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 18))
            .foregroundColor(AppColors.success)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.surfaceCard.cornerRadius(14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColors.divider, lineWidth: 1))
      }
    }
  }

  // ── Plans ──────────────────────────────────────────────────────────────────
  private var plansSection: some View {
    VStack(spacing: 12) {
      // Annual (recommended)
      PlanOptionCard(
        title: "Annual",
        price: pm.annualProduct?.displayPrice ?? "$14.99",
        period: "/ year",
        badge: "Save 60% · Best Value",
        subline: "$1.25 / month",
        isSelected: selectedPlan == PurchaseManager.annualID,
        color: AppColors.primary
      ) { selectedPlan = PurchaseManager.annualID }

      // Monthly
      PlanOptionCard(
        title: "Monthly",
        price: pm.monthlyProduct?.displayPrice ?? "$2.99",
        period: "/ month",
        badge: nil,
        subline: nil,
        isSelected: selectedPlan == PurchaseManager.monthlyID,
        color: AppColors.accent
      ) { selectedPlan = PurchaseManager.monthlyID }
    }
  }

  // ── CTA Button ─────────────────────────────────────────────────────────────
  private var ctaButton: some View {
    Button(action: handlePurchase) {
      ZStack {
        if isPurchasing {
          ProgressView().tint(Color(hex: "1A1030"))
        } else {
          Text(L10n.paywallCta)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color(hex: "1A1030"))
        }
      }
      .frame(maxWidth: .infinity)
      .frame(height: 58)
      .background(AppColors.primaryGradient.cornerRadius(20))
      .shadow(color: AppColors.primary.opacity(0.35), radius: 16, x: 0, y: 6)
    }
    .disabled(isPurchasing)
  }

  // ── Footer ─────────────────────────────────────────────────────────────────
  private var footerSection: some View {
    VStack(spacing: 14) {
      Button(action: { store.markPaywallShown(); dismiss() }) {
        Text(L10n.paywallSkip)
          .font(.system(size: 14))
          .foregroundColor(AppColors.textMuted)
      }

      Button(action: handleRestore) {
        Text(L10n.paywallRestore)
          .font(.system(size: 13))
          .foregroundColor(AppColors.textSecondary)
          .underline()
      }

      Text("Subscriptions auto-renew unless cancelled at least 24h before the end of the current period. Manage in Settings → Apple ID → Subscriptions.")
        .font(.system(size: 10))
        .foregroundColor(AppColors.textMuted)
        .multilineTextAlignment(.center)
        .padding(.top, 4)
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  private func handlePurchase() {
    guard let product = selectedPlan == PurchaseManager.annualID
            ? pm.annualProduct
            : pm.monthlyProduct
    else {
      // Products not loaded yet, retry
      Task { await pm.loadProducts() }
      return
    }

    isPurchasing = true
    Task {
      do {
        let success = try await pm.purchase(product)
        if success {
          store.markPaywallShown()
          dismiss()
        }
      } catch {
        errorMsg = error.localizedDescription
        showError = true
      }
      isPurchasing = false
    }
  }

  private func handleRestore() {
    isPurchasing = true
    Task {
      do {
        try await pm.restore()
        if store.isPremium {
          store.markPaywallShown()
          dismiss()
        } else {
          errorMsg = "No active subscriptions found."
          showError = true
        }
      } catch {
        errorMsg = error.localizedDescription
        showError = true
      }
      isPurchasing = false
    }
  }
}

// ─── Plan Option Card ─────────────────────────────────────────────────────────
private struct PlanOptionCard: View {
  let title: String
  let price: String
  let period: String
  let badge: String?
  let subline: String?
  let isSelected: Bool
  let color: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 16) {
        // Radio button
        ZStack {
          Circle()
            .stroke(isSelected ? color : AppColors.divider, lineWidth: 2)
            .frame(width: 22, height: 22)
          if isSelected {
            Circle().fill(color).frame(width: 12, height: 12)
          }
        }

        // Labels
        VStack(alignment: .leading, spacing: 3) {
          HStack(spacing: 8) {
            Text(title)
              .font(.system(size: 16, weight: .bold))
              .foregroundColor(AppColors.textPrimary)
            if let badge = badge {
              Text(badge)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(Color(hex: "1A1030"))
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(color.cornerRadius(6))
            }
          }
          if let sub = subline {
            Text(sub)
              .font(.system(size: 12))
              .foregroundColor(AppColors.textMuted)
          }
        }

        Spacer()

        // Price
        VStack(alignment: .trailing, spacing: 1) {
          Text(price)
            .font(.system(size: 20, weight: .heavy, design: .rounded))
            .foregroundColor(isSelected ? color : AppColors.textPrimary)
          Text(period)
            .font(.system(size: 11))
            .foregroundColor(AppColors.textMuted)
        }
      }
      .padding(.horizontal, 18)
      .padding(.vertical, 16)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(isSelected ? color.opacity(0.08) : AppColors.surfaceCard)
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(isSelected ? color.opacity(0.5) : AppColors.divider,
                      lineWidth: isSelected ? 1.5 : 1)
          )
      )
    }
    .buttonStyle(PlainButtonStyle())
    .animation(.easeInOut(duration: 0.2), value: isSelected)
  }
}

#Preview {
  PaywallView().environmentObject(Store.shared)
}
