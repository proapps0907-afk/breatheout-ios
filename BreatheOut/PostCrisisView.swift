import SwiftUI

// ─── Post-Crisis View ────────────────────────────────────────────────────────
struct PostCrisisView: View {
  @EnvironmentObject var store: Store
  @Environment(\.dismiss) var dismiss

  let toolUsed: String

  @State private var selectedTrigger: String?
  @State private var intensityBefore: Int = 5
  @State private var intensityAfter: Int = 3
  @State private var notes: String = ""

  let triggers = L10n.triggers

  var body: some View {
    ZStack {
      AppColors.background.ignoresSafeArea()

      ScrollView {
        VStack(spacing: 24) {
          // Header
          VStack(spacing: 8) {
            Text("🌿")
              .font(.system(size: 60))

            Text(L10n.postCrisisTitle)
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(AppColors.textPrimary)
          }
          .padding(.top, 40)

          // Trigger Selection
          VStack(alignment: .leading, spacing: 12) {
            Text(L10n.postCrisisQuestion)
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(AppColors.textPrimary)

            LazyVGrid(columns: [
              GridItem(.flexible()),
              GridItem(.flexible()),
              GridItem(.flexible()),
              GridItem(.flexible())
            ], spacing: 12) {
              ForEach(triggers, id: \.1) { trigger in
                TriggerButton(
                  emoji: trigger.0,
                  title: L10n.t(trigger.1, trigger.2),
                  isSelected: selectedTrigger == trigger.1
                ) {
                  selectedTrigger = trigger.1
                }
              }
            }
          }
          .padding(20)
          .background(AppColors.surfaceCard.cornerRadius(20))

          // Intensity Slider
          VStack(alignment: .leading, spacing: 16) {
            Text("How are you feeling now?")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(AppColors.textPrimary)

            HStack {
              Text("Before")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
              Slider(
                value: Binding(
                  get: { Double(intensityBefore) },
                  set: { intensityBefore = Int($0) }
                ),
                in: 1...10,
                step: 1
              )
              .tint(AppColors.sos)
              Text("\(intensityBefore)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(AppColors.sos)
                .frame(width: 30)
            }

            HStack {
              Text("After")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
              Slider(
                value: Binding(
                  get: { Double(intensityAfter) },
                  set: { intensityAfter = Int($0) }
                ),
                in: 1...10,
                step: 1
              )
              .tint(AppColors.success)
              Text("\(intensityAfter)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(AppColors.success)
                .frame(width: 30)
            }
          }
          .padding(20)
          .background(AppColors.surfaceCard.cornerRadius(20))

          // Notes
          VStack(alignment: .leading, spacing: 12) {
            Text("Notes (optional)")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(AppColors.textPrimary)

            TextEditor(text: $notes)
              .font(.system(size: 16, weight: .regular))
              .foregroundColor(AppColors.textPrimary)
              .frame(minHeight: 120)
              .padding(12)
              .background(AppColors.surface.cornerRadius(12))
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(AppColors.divider, lineWidth: 1)
              )
          }
          .padding(20)
          .background(AppColors.surfaceCard.cornerRadius(20))

          // Actions
          HStack(spacing: 16) {
            Button(action: {
              saveEntry()
              dismiss()
            }) {
              Text(L10n.postCrisisSkip)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.surface.cornerRadius(16))
            }

            Button(action: {
              saveEntry()
              dismiss()
            }) {
              Text(L10n.postCrisisSave)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "1A1030"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.primaryGradient)
                .cornerRadius(16)
            }
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
      }
    }
  }

  private func saveEntry() {
    let entry = CrisisEntry(
      trigger: selectedTrigger ?? "Other",
      toolUsed: toolUsed.isEmpty ? "Breathing" : toolUsed,
      intensityBefore: intensityBefore,
      intensityAfter: intensityAfter,
      notes: notes.isEmpty ? nil : notes
    )
    store.addEntry(entry)
  }
}

// ─── Trigger Button ──────────────────────────────────────────────────────────
struct TriggerButton: View {
  let emoji: String
  let title: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        Text(emoji)
          .font(.system(size: 28))
        Text(title)
          .font(.system(size: 11, weight: .medium))
          .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
          .lineLimit(1)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 12)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(isSelected ? AppColors.primary : AppColors.surface)
      )
    }
  }
}

#Preview {
  PostCrisisView(toolUsed: "4-7-8 Breathing")
    .environmentObject(Store.shared)
}
