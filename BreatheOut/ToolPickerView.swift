import SwiftUI

// ─── Tool Picker View ─────────────────────────────────────────────────────────
struct ToolPickerView: View {
  @EnvironmentObject var store: Store
  @Environment(\.dismiss) var dismiss

  @State private var showBreathing = false
  @State private var showGrounding = false
  @State private var showPostCrisis = false
  @State private var completedTool = ""

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: "0D0D1A"), Color(hex: "12122A")],
        startPoint: .top, endPoint: .bottom
      ).ignoresSafeArea()

      VStack(alignment: .leading, spacing: 0) {
        // Back button
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(AppColors.textSecondary)
            .padding(16)
        }
        .padding(.top, 8)

        // Title
        VStack(alignment: .leading, spacing: 4) {
          Text(L10n.toolTitleEn)
            .font(.system(size: 30, weight: .heavy))
            .foregroundColor(AppColors.textPrimary)
          Text(L10n.toolTitleEs)
            .font(.system(size: 15))
            .foregroundColor(AppColors.textMuted)
        }
        .padding(.horizontal, 28)
        .padding(.top, 8)
        .padding(.bottom, 24)

        // Tool Cards
        ScrollView(showsIndicators: false) {
          VStack(spacing: 16) {
            ToolCard(
              emoji: "🫁",
              titleEn: L10n.breathingTitleEn,
              titleEs: L10n.breathingTitleEs,
              descEn: L10n.breathingDescEn,
              descEs: L10n.breathingDescEs,
              duration: "~4 min",
              cardColors: [Color(hex: "1A2A38"), Color(hex: "0D1A24")],
              accentColor: AppColors.accent
            ) {
              Haptics.medium()
              showBreathing = true
            }

            ToolCard(
              emoji: "🖐️",
              titleEn: L10n.groundingTitleEn,
              titleEs: L10n.groundingTitleEs,
              descEn: L10n.groundingDescEn,
              descEs: L10n.groundingDescEs,
              duration: "~5 min",
              cardColors: [Color(hex: "221A38"), Color(hex: "14102A")],
              accentColor: AppColors.primary
            ) {
              Haptics.medium()
              showGrounding = true
            }
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 32)
        }
      }
    }
    .fullScreenCover(isPresented: $showBreathing) {
      BreathingView(onComplete: { cycles in
        showBreathing = false
        if cycles > 0 {
          completedTool = "4-7-8 Breathing"
          showPostCrisis = true
        }
      }).environmentObject(store)
    }
    .fullScreenCover(isPresented: $showGrounding) {
      GroundingView(onComplete: { steps in
        showGrounding = false
        if steps > 0 {
          completedTool = "5-4-3-2-1 Grounding"
          showPostCrisis = true
        }
      }).environmentObject(store)
    }
    .fullScreenCover(isPresented: $showPostCrisis, onDismiss: { dismiss() }) {
      PostCrisisView(toolUsed: completedTool).environmentObject(store)
    }
  }
}

// ─── Tool Card ────────────────────────────────────────────────────────────────
private struct ToolCard: View {
  let emoji: String
  let titleEn: String
  let titleEs: String
  let descEn: String
  let descEs: String
  let duration: String
  let cardColors: [Color]
  let accentColor: Color
  let action: () -> Void

  @State private var pressed = false

  var body: some View {
    Button(action: action) {
      ZStack(alignment: .bottomTrailing) {
        VStack(alignment: .leading, spacing: 0) {
          // Top row: emoji + duration badge
          HStack(alignment: .top) {
            Text(emoji).font(.system(size: 44))
            Spacer()
            Text(duration)
              .font(.system(size: 12, weight: .semibold))
              .foregroundColor(accentColor)
              .padding(.horizontal, 12)
              .padding(.vertical, 6)
              .background(accentColor.opacity(0.12).cornerRadius(10))
          }

          Spacer().frame(height: 24)

          // Title
          Text(titleEn)
            .font(.system(size: 22, weight: .heavy))
            .foregroundColor(AppColors.textPrimary)
          Text(titleEs)
            .font(.system(size: 13))
            .foregroundColor(AppColors.textMuted)
            .padding(.top, 2)

          Spacer().frame(height: 14)

          // Description
          Text(descEn)
            .font(.system(size: 14))
            .foregroundColor(accentColor.opacity(0.85))
            .lineSpacing(2)
          Text(descEs)
            .font(.system(size: 12))
            .foregroundColor(AppColors.textMuted)
            .padding(.top, 4)
            .lineSpacing(2)

          Spacer().frame(height: 24)

          // Arrow
          HStack {
            Spacer()
            ZStack {
              Circle()
                .fill(accentColor.opacity(0.15))
                .frame(width: 40, height: 40)
              Image(systemName: "arrow.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(accentColor)
            }
          }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
          LinearGradient(colors: cardColors, startPoint: .topLeading, endPoint: .bottomTrailing)
            .cornerRadius(28)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 28)
            .stroke(accentColor.opacity(0.25), lineWidth: 1.5)
        )
        .shadow(color: accentColor.opacity(0.15), radius: 20, x: 0, y: 8)
      }
    }
    .buttonStyle(ScaleButtonStyle())
  }
}

// ─── Scale Press Button Style ─────────────────────────────────────────────────
private struct ScaleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
      .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
  }
}

#Preview {
  ToolPickerView().environmentObject(Store.shared)
}
