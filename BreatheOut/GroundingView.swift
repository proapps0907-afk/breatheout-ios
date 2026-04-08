import SwiftUI

// ─── Grounding View (5-4-3-2-1 Technique) ────────────────────────────────────
struct GroundingView: View {
  let onComplete: (Int) -> Void

  @State private var stepIndex = 0
  @State private var tapCount = 0
  @State private var isDone = false
  @State private var fadeOpacity: Double = 0

  private let steps = L10n.groundingSteps
  private var targetTaps: Int { 5 - stepIndex }

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: "0D0D1A"), Color(hex: "12122A")],
        startPoint: .top, endPoint: .bottom
      ).ignoresSafeArea()

      VStack(spacing: 0) {
        topBar.padding(.top, 16)
        headerSection.padding(.top, 16)
        Spacer()
        if isDone {
          doneDisplay
        } else {
          stepContent.opacity(fadeOpacity)
        }
        Spacer()
        if !isDone {
          tapButton.padding(.horizontal, 24).padding(.bottom, 24)
        }
      }
    }
    .onAppear { withAnimation(.easeOut(duration: 0.5)) { fadeOpacity = 1.0 } }
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────
  private var topBar: some View {
    HStack {
      Button(action: { onComplete(0) }) {
        Image(systemName: "xmark")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(AppColors.textMuted)
          .padding(12)
      }
      Spacer()
      HStack(spacing: 6) {
        ForEach(0..<steps.count, id: \.self) { i in
          RoundedRectangle(cornerRadius: 4)
            .fill(i <= stepIndex ? AppColors.primary : AppColors.divider)
            .frame(width: i == stepIndex ? 24 : 8, height: 8)
            .animation(.easeInOut(duration: 0.3), value: stepIndex)
        }
      }
      .padding(.trailing, 24)
    }
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  private var headerSection: some View {
    VStack(spacing: 4) {
      Text(L10n.groundingTitleEn)
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(AppColors.textSecondary)
      Text(L10n.groundingIntroEn)
        .font(.system(size: 13))
        .foregroundColor(AppColors.textMuted)
        .multilineTextAlignment(.center)
    }
    .padding(.horizontal, 24)
  }

  // ── Step Content ───────────────────────────────────────────────────────────
  private var stepContent: some View {
    let step = steps[stepIndex]
    return VStack(spacing: 0) {
      Text(step.emoji).font(.system(size: 72))
      Spacer().frame(height: 16)
      Text(step.en)
        .font(.system(size: 24, weight: .heavy))
        .foregroundColor(AppColors.textPrimary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
      Text(step.es)
        .font(.system(size: 14))
        .foregroundColor(AppColors.textMuted)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
        .padding(.top, 6)
      Spacer().frame(height: 32)
      // Tap progress dots
      HStack(spacing: 8) {
        ForEach(0..<targetTaps, id: \.self) { i in
          let tapped = i < tapCount
          ZStack {
            Circle()
              .fill(tapped ? AppColors.primary.opacity(0.8) : AppColors.surfaceCard)
              .frame(width: tapped ? 44 : 36, height: tapped ? 44 : 36)
              .overlay(Circle().stroke(tapped ? AppColors.primary : AppColors.divider, lineWidth: 2))
              .shadow(color: tapped ? AppColors.primary.opacity(0.3) : .clear, radius: 12)
            if tapped {
              Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            }
          }
          .animation(.spring(response: 0.2), value: tapped)
        }
      }
    }
  }

  // ── Done Display ───────────────────────────────────────────────────────────
  private var doneDisplay: some View {
    VStack(spacing: 16) {
      Text("🌿").font(.system(size: 72))
      Text(L10n.groundingDoneEn)
        .font(.system(size: 22, weight: .bold))
        .foregroundColor(AppColors.textPrimary)
        .multilineTextAlignment(.center)
      Text(L10n.groundingDoneEs)
        .font(.system(size: 14))
        .foregroundColor(AppColors.textMuted)
        .multilineTextAlignment(.center)
    }
    .padding(.horizontal, 32)
  }

  // ── TAP HERE Button ────────────────────────────────────────────────────────
  private var tapButton: some View {
    let remaining = targetTaps - tapCount
    return Button(action: handleTap) {
      VStack(spacing: 4) {
        Text("TAP HERE")
          .font(.system(size: 22, weight: .heavy))
          .foregroundColor(.white)
          .tracking(2)
        Text(remaining > 0 ? "\(remaining) more to go • \(remaining) más" : "✓ Step complete!")
          .font(.system(size: 12))
          .foregroundColor(.white.opacity(0.7))
      }
      .frame(maxWidth: .infinity)
      .frame(height: 120)
      .background(
        LinearGradient(
          colors: [AppColors.primaryDeep, AppColors.primaryGlow],
          startPoint: .topLeading, endPoint: .bottomTrailing
        ).cornerRadius(28)
      )
      .shadow(color: AppColors.primary.opacity(0.3), radius: 24, x: 0, y: 8)
    }
    .buttonStyle(GroundingTapStyle())
  }

  // ── Logic ──────────────────────────────────────────────────────────────────
  private func handleTap() {
    Haptics.medium()
    tapCount += 1
    if tapCount >= targetTaps {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        if stepIndex >= steps.count - 1 {
          Haptics.success()
          withAnimation { isDone = true }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) { onComplete(steps.count) }
        } else {
          nextStep()
        }
      }
    }
  }

  private func nextStep() {
    Haptics.success()
    withAnimation(.easeOut(duration: 0.3)) { fadeOpacity = 0 }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      stepIndex += 1
      tapCount = 0
      withAnimation(.easeOut(duration: 0.5)) { fadeOpacity = 1 }
    }
  }
}

private struct GroundingTapStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
  }
}

#Preview {
  GroundingView(onComplete: { _ in })
}
