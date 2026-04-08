import SwiftUI

// ─── Home View ───────────────────────────────────────────────────────────────
struct HomeView: View {
  @EnvironmentObject var store: Store
  @State private var showToolPicker = false
  @State private var showSOS = false
  @State private var showJournal = false
  @State private var pulseScale: CGFloat = 1.0

  private var isNight: Bool {
    let h = Calendar.current.component(.hour, from: Date())
    return h >= 22 || h < 6
  }

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: "0D0D1A"), Color(hex: "12122A")],
        startPoint: .top, endPoint: .bottom
      ).ignoresSafeArea()

      VStack(spacing: 0) {
        topBar
        Spacer(minLength: 0)
        greetingSection
        Spacer(minLength: 0)
        helpNowCircle
        Spacer(minLength: 24)
        if !store.entries.isEmpty { lastSessionBadge }
        Spacer(minLength: 0)
        sosButton
          .padding(.horizontal, 24)
          .padding(.bottom, 24)
      }
    }
    .fullScreenCover(isPresented: $showToolPicker) {
      ToolPickerView().environmentObject(store)
    }
    .sheet(isPresented: $showSOS) {
      SOSView().environmentObject(store)
    }
    .sheet(isPresented: $showJournal) {
      JournalView().environmentObject(store)
    }
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────
  private var topBar: some View {
    HStack {
      Text("🌬️").font(.system(size: 24))
      Spacer()
      Button(action: { showJournal = true }) {
        HStack(spacing: 6) {
          Image(systemName: "chart.line.uptrend.xyaxis")
            .font(.system(size: 16))
            .foregroundColor(AppColors.textSecondary)
          if !store.entries.isEmpty {
            Text("\(store.entries.count)")
              .font(.system(size: 12, weight: .semibold))
              .foregroundColor(AppColors.textSecondary)
          }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(AppColors.surfaceCard)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColors.divider, lineWidth: 1))
        )
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 16)
  }

  // ── Greeting ───────────────────────────────────────────────────────────────
  private var greetingSection: some View {
    VStack(spacing: 6) {
      Text(isNight ? L10n.homeGreetingNightEn : L10n.homeGreetingDayEn)
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(AppColors.textPrimary)
        .multilineTextAlignment(.center)
      Text(isNight ? L10n.homeGreetingNightEs : L10n.homeGreetingDayEs)
        .font(.system(size: 15))
        .foregroundColor(AppColors.textMuted)
    }
    .padding(.horizontal, 32)
  }

  // ── Central Help Button ────────────────────────────────────────────────────
  private var helpNowCircle: some View {
    let btnSize = UIScreen.main.bounds.width * 0.72

    return Button(action: {
      Haptics.medium()
      showToolPicker = true
    }) {
      ZStack {
        // Outer glow ring
        Circle()
          .fill(AppColors.primary.opacity(0.06))
          .frame(width: btnSize, height: btnSize)

        // Middle glow ring
        Circle()
          .fill(AppColors.primary.opacity(0.10))
          .frame(width: btnSize * 0.85, height: btnSize * 0.85)

        // Main filled circle
        Circle()
          .fill(
            LinearGradient(
              colors: [AppColors.primary, AppColors.primaryGlow],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: btnSize * 0.72, height: btnSize * 0.72)
          .shadow(color: AppColors.primary.opacity(0.4), radius: 40)

        // Content
        VStack(spacing: 10) {
          Text("🫁").font(.system(size: 40))

          Text(L10n.helpNowBtnEn)
            .font(.system(size: 16, weight: .heavy))
            .foregroundColor(Color(hex: "1A1030"))
            .multilineTextAlignment(.center)

          Text(L10n.helpNowBtnEs)
            .font(.system(size: 11))
            .foregroundColor(Color(hex: "1A1030").opacity(0.5))
        }
      }
    }
    .buttonStyle(PlainButtonStyle())
    .scaleEffect(pulseScale)
    .onAppear {
      withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
        pulseScale = 1.025
      }
    }
  }

  // ── Last Session Badge ─────────────────────────────────────────────────────
  private var lastSessionBadge: some View {
    let last = store.entries.first!
    let diff = Date().timeIntervalSince(last.timestamp)
    let ago: String = {
      if diff < 3600 { return "\(Int(diff / 60))m ago" }
      if diff < 86400 { return "\(Int(diff / 3600))h ago" }
      return "\(Int(diff / 86400))d ago"
    }()

    return HStack(spacing: 6) {
      Image(systemName: "clock.arrow.circlepath")
        .font(.system(size: 12))
        .foregroundColor(AppColors.textMuted)
      Text("Last session \(ago)")
        .font(.system(size: 12))
        .foregroundColor(AppColors.textMuted)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 10)
    .background(
      RoundedRectangle(cornerRadius: 14)
        .fill(AppColors.surfaceCard)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColors.divider, lineWidth: 1))
    )
  }

  // ── SOS Button ─────────────────────────────────────────────────────────────
  private var sosButton: some View {
    Button(action: {
      Haptics.light()
      showSOS = true
    }) {
      HStack(spacing: 8) {
        Image(systemName: "phone.fill")
          .font(.system(size: 18))
          .foregroundColor(AppColors.sos)

        VStack(alignment: .leading, spacing: 2) {
          Text(L10n.sosBtnEn)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(AppColors.sos)
          Text(L10n.sosBtnEs)
            .font(.system(size: 11))
            .foregroundColor(AppColors.sosDark)
        }
      }
      .frame(maxWidth: .infinity)
      .frame(height: 56)
      .background(
        RoundedRectangle(cornerRadius: 18)
          .fill(AppColors.sos.opacity(0.08))
          .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColors.sos.opacity(0.3), lineWidth: 1))
      )
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  HomeView().environmentObject(Store.shared)
}
