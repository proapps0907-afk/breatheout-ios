import SwiftUI

// ─── Hotline Model ────────────────────────────────────────────────────────────
struct Hotline {
  let country: String
  let name: String
  let number: String
  let textNumber: String?
  let descriptionEs: String
  let canCall: Bool
  let canText: Bool
}

// ─── Hotline Data ─────────────────────────────────────────────────────────────
enum HotlineData {
  static let all: [Hotline] = [
    Hotline(country: "🇺🇸 USA", name: "National Suicide & Crisis Lifeline",
            number: "988", textNumber: "988",
            descriptionEs: "Llama o envía mensaje — disponible 24/7",
            canCall: true, canText: true),
    Hotline(country: "🇺🇸 USA", name: "Crisis Text Line",
            number: "741741", textNumber: "741741",
            descriptionEs: "Envía HOME al 741741",
            canCall: false, canText: true),
    Hotline(country: "🇺🇸 USA", name: "Veterans Crisis Line",
            number: "1-800-273-8255", textNumber: "838255",
            descriptionEs: "Presiona 1 después de marcar",
            canCall: true, canText: true),
    Hotline(country: "🇺🇸 USA (Spanish)", name: "Línea de Crisis en Español",
            number: "1-888-628-9454", textNumber: nil,
            descriptionEs: "Línea en Español — 24 horas",
            canCall: true, canText: false),
    Hotline(country: "🇲🇽 México", name: "SAPTEL — Crisis Line",
            number: "55 5259-8121", textNumber: nil,
            descriptionEs: "Apoyo psicológico 24 horas",
            canCall: true, canText: false),
    Hotline(country: "🇲🇽 México", name: "CONÁSAME — Línea de la Vida",
            number: "800 911 2000", textNumber: nil,
            descriptionEs: "Gratuita, disponible 24/7",
            canCall: true, canText: false),
  ]
}

// ─── SOS View ────────────────────────────────────────────────────────────────
struct SOSView: View {
  @EnvironmentObject var store: Store
  @Environment(\.dismiss) var dismiss

  var body: some View {
    ZStack {
      Color(hex: "1A1A2E").ignoresSafeArea()

      VStack(spacing: 0) {
        // Drag indicator
        Capsule()
          .fill(AppColors.textMuted.opacity(0.4))
          .frame(width: 40, height: 4)
          .padding(.top, 12)

        // Header
        VStack(spacing: 12) {
          ZStack {
            Circle()
              .fill(AppColors.sos.opacity(0.15))
              .frame(width: 64, height: 64)
            Image(systemName: "heart.fill")
              .font(.system(size: 28))
              .foregroundColor(AppColors.sos)
          }

          Text(L10n.sosTitleEn)
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(AppColors.textPrimary)
            .multilineTextAlignment(.center)

          VStack(spacing: 4) {
            Text(L10n.sosSubtitleEn)
              .font(.system(size: 14))
              .foregroundColor(AppColors.textSecondary)
              .multilineTextAlignment(.center)
            Text(L10n.sosSubtitleEs)
              .font(.system(size: 13))
              .foregroundColor(AppColors.textMuted)
              .multilineTextAlignment(.center)
          }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 20)

        Divider().background(AppColors.divider)

        // Hotlines list
        ScrollView(showsIndicators: false) {
          VStack(spacing: 8) {
            ForEach(HotlineData.all, id: \.name) { hotline in
              HotlineCard(hotline: hotline)
            }
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
        }

        // Close button
        Button(action: { dismiss() }) {
          Text("Close / Cerrar")
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(AppColors.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
      }
    }
  }
}

// ─── Hotline Card ─────────────────────────────────────────────────────────────
private struct HotlineCard: View {
  let hotline: Hotline

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // Country badge
      Text(hotline.country)
        .font(.system(size: 11, weight: .semibold))
        .foregroundColor(AppColors.sos)
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(AppColors.sos.opacity(0.12).cornerRadius(8))

      Text(hotline.name)
        .font(.system(size: 15, weight: .semibold))
        .foregroundColor(AppColors.textPrimary)

      Text(hotline.number)
        .font(.system(size: 20, weight: .heavy, design: .rounded))
        .foregroundColor(AppColors.primary)

      Text(hotline.descriptionEs)
        .font(.system(size: 12))
        .foregroundColor(AppColors.textMuted)

      HStack(spacing: 8) {
        if hotline.canCall {
          ActionButton(label: "Call / Llamar", icon: "phone.fill", color: AppColors.success) {
            call(hotline.number)
          }
        }
        if hotline.canText, let txt = hotline.textNumber {
          ActionButton(label: "Text / Mensaje", icon: "message.fill", color: AppColors.accent) {
            text(txt)
          }
        }
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(AppColors.surfaceCard.cornerRadius(16))
    .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.divider, lineWidth: 1))
  }

  private func call(_ number: String) {
    let clean = number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    if let url = URL(string: "tel://\(clean)") { UIApplication.shared.open(url) }
  }

  private func text(_ number: String) {
    let clean = number.replacingOccurrences(of: " ", with: "")
    if let url = URL(string: "sms://\(clean)") { UIApplication.shared.open(url) }
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────
private struct ActionButton: View {
  let label: String
  let icon: String
  let color: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 6) {
        Image(systemName: icon).font(.system(size: 13))
        Text(label).font(.system(size: 13, weight: .semibold))
      }
      .foregroundColor(color)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 10)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(color.opacity(0.15))
          .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
      )
    }
  }
}

#Preview {
  SOSView().environmentObject(Store.shared)
}
