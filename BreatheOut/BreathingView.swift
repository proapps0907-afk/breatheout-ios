import SwiftUI

// ─── Breathing View (4-7-8 Technique) ────────────────────────────────────────
struct BreathingView: View {
  let onComplete: (Int) -> Void

  @State private var phase: BreathPhase = .inhale
  @State private var cycle: Int = 1
  @State private var secsLeft: Int = 4
  @State private var circleProgress: CGFloat = 0.0
  @State private var isDone = false
  @State private var countTimer: Timer? = nil

  private let totalCycles = 4
  private let screenWidth = UIScreen.main.bounds.width

  enum BreathPhase: CaseIterable, Equatable {
    case inhale, hold, exhale
    var duration: Int {
      switch self { case .inhale: return 4; case .hold: return 7; case .exhale: return 8 }
    }
    var labelEn: String {
      switch self { case .inhale: return L10n.breatheIn; case .hold: return L10n.holdBreath; case .exhale: return L10n.breatheOut }
    }
    var labelEs: String {
      switch self { case .inhale: return L10n.breatheInEs; case .hold: return L10n.holdBreathEs; case .exhale: return L10n.breatheOutEs }
    }
    var color: Color {
      switch self { case .inhale: return AppColors.accent; case .hold: return AppColors.warning; case .exhale: return AppColors.primary }
    }
    var chipLabel: String {
      switch self { case .inhale: return "4s"; case .hold: return "7s"; case .exhale: return "8s" }
    }
    var chipSubtitle: String {
      switch self { case .inhale: return "Inhale / Inhala"; case .hold: return "Hold / Sostén"; case .exhale: return "Exhale / Exhala" }
    }
  }

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: "0D0D1A"), Color(hex: "12122A")],
        startPoint: .top, endPoint: .bottom
      ).ignoresSafeArea()

      VStack(spacing: 0) {
        topBar.padding(.top, 16)
        titleSection.padding(.top, 24)
        Spacer()
        if isDone { doneDisplay } else { breathingCircleView }
        Spacer()
        if !isDone { phaseChipsRow.padding(.horizontal, 32) }
        Spacer().frame(height: 32)
      }
    }
    .onAppear { beginPhase(.inhale) }
    .onDisappear { countTimer?.invalidate() }
  }

  private var topBar: some View {
    HStack {
      Button(action: { countTimer?.invalidate(); onComplete(0) }) {
        Image(systemName: "xmark")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(AppColors.textMuted)
          .padding(12)
      }
      Spacer()
      HStack(spacing: 6) {
        ForEach(0..<totalCycles, id: \.self) { i in
          RoundedRectangle(cornerRadius: 4)
            .fill(i < cycle ? AppColors.accent : AppColors.divider)
            .frame(width: i == cycle - 1 ? 24 : 8, height: 8)
            .animation(.easeInOut(duration: 0.3), value: cycle)
        }
      }
      .padding(.trailing, 24)
    }
  }

  private var titleSection: some View {
    VStack(spacing: 4) {
      Text(L10n.breathingTitleEn)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(AppColors.textSecondary)
      Text("Cycle \(cycle) of \(totalCycles)")
        .font(.system(size: 13))
        .foregroundColor(AppColors.textMuted)
    }
  }

  private var breathingCircleView: some View {
    let maxSize = screenWidth * 0.78
    let circleSize = maxSize * (0.55 + 0.45 * circleProgress)
    return ZStack {
      Circle().fill(phase.color.opacity(0.06)).frame(width: circleSize + 40, height: circleSize + 40)
      Circle().fill(phase.color.opacity(0.10)).frame(width: circleSize + 20, height: circleSize + 20)
      Circle()
        .fill(RadialGradient(colors: [phase.color.opacity(0.35), phase.color.opacity(0.15)],
                             center: .center, startRadius: 0, endRadius: circleSize / 2))
        .frame(width: circleSize, height: circleSize)
        .overlay(Circle().stroke(phase.color.opacity(0.6), lineWidth: 2))
        .shadow(color: phase.color.opacity(0.3), radius: 40)
      VStack(spacing: 4) {
        Text("\(max(secsLeft, 0))")
          .font(.system(size: 52, weight: .heavy, design: .rounded))
          .foregroundColor(phase.color)
          .monospacedDigit()
        Text(phase.labelEn)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(AppColors.textPrimary)
          .tracking(1)
        Text(phase.labelEs)
          .font(.system(size: 12))
          .foregroundColor(AppColors.textMuted)
      }
    }
    .frame(width: maxSize, height: maxSize)
    .animation(.easeInOut(duration: 0.3), value: circleSize)
  }

  private var doneDisplay: some View {
    VStack(spacing: 24) {
      ZStack {
        Circle().fill(AppColors.success.opacity(0.15)).frame(width: 100, height: 100)
          .overlay(Circle().stroke(AppColors.success.opacity(0.4), lineWidth: 2))
        Text("✅").font(.system(size: 48))
      }
      Text(L10n.breathingDoneEn)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(AppColors.textPrimary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
      Text(L10n.breathingDoneEs)
        .font(.system(size: 14))
        .foregroundColor(AppColors.textMuted)
        .multilineTextAlignment(.center)
    }
  }

  private var phaseChipsRow: some View {
    HStack(spacing: 0) {
      ForEach(BreathPhase.allCases, id: \.self) { p in
        BreathPhaseChip(label: p.chipLabel, subtitle: p.chipSubtitle, active: phase == p, color: p.color)
        if p != .exhale {
          Image(systemName: "chevron.right")
            .font(.system(size: 10))
            .foregroundColor(AppColors.textMuted)
            .padding(.horizontal, 2)
        }
      }
    }
  }

  private func beginPhase(_ newPhase: BreathPhase) {
    countTimer?.invalidate()
    phase = newPhase
    secsLeft = newPhase.duration
    switch newPhase {
    case .inhale:
      circleProgress = 0.0
      withAnimation(.easeInOut(duration: Double(newPhase.duration))) { circleProgress = 1.0 }
    case .hold:
      circleProgress = 1.0
    case .exhale:
      withAnimation(.easeInOut(duration: Double(newPhase.duration))) { circleProgress = 0.0 }
    }
    let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      DispatchQueue.main.async {
        self.secsLeft -= 1
        if self.secsLeft <= 0 { timer.invalidate(); self.nextPhase() }
      }
    }
    RunLoop.main.add(t, forMode: .common)
    countTimer = t
  }

  private func nextPhase() {
    switch phase {
    case .inhale: beginPhase(.hold)
    case .hold:   beginPhase(.exhale)
    case .exhale:
      if cycle >= totalCycles { finishSession() } else { cycle += 1; beginPhase(.inhale) }
    }
  }

  private func finishSession() {
    isDone = true
    Haptics.success()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { onComplete(totalCycles) }
  }
}

// ─── Phase Chip ───────────────────────────────────────────────────────────────
struct BreathPhaseChip: View {
  let label: String
  let subtitle: String
  let active: Bool
  let color: Color

  var body: some View {
    VStack(spacing: 2) {
      Text(label).font(.system(size: 16, weight: .heavy))
        .foregroundColor(active ? color : AppColors.textMuted)
      Text(subtitle).font(.system(size: 9))
        .foregroundColor(AppColors.textMuted)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 8).padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(active ? color.opacity(0.15) : AppColors.surfaceCard)
        .overlay(RoundedRectangle(cornerRadius: 12)
          .stroke(active ? color.opacity(0.5) : AppColors.divider, lineWidth: 1))
    )
    .animation(.easeInOut(duration: 0.3), value: active)
  }
}

#Preview {
  BreathingView(onComplete: { _ in })
}
