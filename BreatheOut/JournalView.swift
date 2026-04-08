import SwiftUI

// ─── Journal View ────────────────────────────────────────────────────────────
struct JournalView: View {
  @EnvironmentObject var store: Store
  @Environment(\.dismiss) var dismiss

  var body: some View {
    NavigationView {
      ZStack {
        AppColors.background.ignoresSafeArea()

        if store.entries.isEmpty {
          emptyState
        } else {
          journalList
        }
      }
      .navigationTitle(L10n.historyTitle)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { dismiss() }) {
            Image(systemName: "xmark")
              .foregroundColor(AppColors.textSecondary)
          }
        }
      }
    }
  }

  // ── Empty State ────────────────────────────────────────────────────────────
  private var emptyState: some View {
    VStack(spacing: 20) {
      Text("📔")
        .font(.system(size: 80))

      Text(L10n.historyEmpty)
        .font(.system(size: 16, weight: .regular))
        .foregroundColor(AppColors.textMuted)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }
  }

  // ── Journal List ───────────────────────────────────────────────────────────
  private var journalList: some View {
    ScrollView {
      VStack(spacing: 12) {
        ForEach(store.entries) { entry in
          JournalEntryCard(entry: entry, onDelete: {
            if let index = store.entries.firstIndex(where: { $0.id == entry.id }) {
              store.deleteEntry(at: index)
            }
          })
        }
      }
      .padding(.horizontal, 24)
      .padding(.top, 20)
      .padding(.bottom, 40)
    }
  }
}

// ─── Journal Entry Card ──────────────────────────────────────────────────────
struct JournalEntryCard: View {
  let entry: CrisisEntry
  let onDelete: () -> Void

  @State private var showDeleteConfirm = false

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Header
      HStack {
        HStack(spacing: 8) {
          Text(entry.trigger)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(AppColors.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.primary.opacity(0.2).cornerRadius(8))

          Text(entry.toolUsed)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(AppColors.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.surface.cornerRadius(8))
        }

        Spacer()

        Text(entry.timestamp, style: .date)
          .font(.system(size: 12, weight: .regular))
          .foregroundColor(AppColors.textMuted)
      }

      // Intensity
      if let after = entry.intensityAfter {
        HStack(spacing: 8) {
          Text("Intensity:")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(AppColors.textMuted)

          Text("\(entry.intensityBefore) → \(after)")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(after < entry.intensityBefore ? AppColors.success : AppColors.textPrimary)
        }
      }

      // Notes
      if let notes = entry.notes, !notes.isEmpty {
        Text(notes)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(AppColors.textSecondary)
          .padding(12)
          .background(AppColors.surface.cornerRadius(12))
      }

      // Delete button
      HStack {
        Spacer()
        Button(action: { showDeleteConfirm = true }) {
          Image(systemName: "trash")
            .font(.system(size: 14))
            .foregroundColor(AppColors.sos)
            .padding(8)
        }
      }
    }
    .padding(20)
    .background(AppColors.surfaceCard.cornerRadius(20))
    .confirmationDialog("Delete this entry?", isPresented: $showDeleteConfirm) {
      Button("Delete", role: .destructive, action: onDelete)
      Button("Cancel", role: .cancel) {}
    }
  }
}

#Preview {
  JournalView()
    .environmentObject(Store.shared)
}
