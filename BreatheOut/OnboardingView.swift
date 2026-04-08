import SwiftUI

// ─── Onboarding View ─────────────────────────────────────────────────────────
struct OnboardingView: View {
  @EnvironmentObject var store: Store
  @State private var scale: CGFloat = 0.9
  @State private var opacity: CGFloat = 0

  var body: some View {
    ZStack {
      AppColors.background.ignoresSafeArea()

      VStack(spacing: 0) {
        Spacer()

        // Logo / App Icon placeholder
        ZStack {
          Circle()
            .fill(AppColors.primaryGradient)
            .frame(width: 120, height: 120)

          Text("🌿")
            .font(.system(size: 60))
        }
        .scaleEffect(scale)
        .opacity(opacity)

        Spacer()
          .frame(height: 40)

        // Title
        Text("BreatheOut")
          .font(.system(size: 48, weight: .bold, design: .rounded))
          .foregroundColor(AppColors.textPrimary)

        Text(L10n.appTagline)
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(AppColors.textSecondary)
          .padding(.top, 8)

        Spacer()
          .frame(height: 48)

        // Privacy Badge
        HStack {
          Text(L10n.privacyBadge)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(AppColors.textMuted)
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(AppColors.surface.cornerRadius(12))
        .padding(.horizontal, 24)

        Spacer()
          .frame(height: 32)

        // Medical Disclaimer
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "exclamationmark.triangle.fill")
              .foregroundColor(AppColors.warning)
            Text("Medical Disclaimer")
              .font(.system(size: 16, weight: .bold))
              .foregroundColor(AppColors.textPrimary)
          }

          Text(L10n.medicalDisclaimer)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(AppColors.textSecondary)
            .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surfaceCard.cornerRadius(16))
        .padding(.horizontal, 24)

        Spacer()
          .frame(height: 32)

        // CTA Button
        Button(action: {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            store.completeOnboarding()
          }
        }) {
          HStack {
            Text(L10n.onboardingCta)
              .font(.system(size: 18, weight: .bold))
            Image(systemName: "arrow.right")
              .font(.system(size: 16, weight: .bold))
          }
          .foregroundColor(Color(hex: "1A1030"))
          .padding(.horizontal, 32)
          .padding(.vertical, 18)
          .background(AppColors.primaryGradient)
          .cornerRadius(20)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)

        Spacer()
      }
      .padding(.top, 60)
    }
    .onAppear {
      withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
        scale = 1.0
        opacity = 1.0
      }
    }
  }
}

#Preview {
  OnboardingView()
    .environmentObject(Store.shared)
}
