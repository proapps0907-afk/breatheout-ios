import Foundation

// ─── Bilingual strings: English UI + Spanish subtitles ───────────────────────
struct L10n {
  static var isSpanish: Bool = false

  static func t(_ en: String, _ es: String) -> String {
    return isSpanish ? es : en
  }

  // ── Onboarding ─────────────────────────────────────────────────────────────
  static let appTagline = t("Emotional First Aid Kit", "Tu botiquín emocional de emergencia")
  static let privacyBadge = t("🔒 No account needed. Your data never leaves this phone.", "Sin cuenta. Tus datos nunca salen de este teléfono.")
  static let medicalDisclaimer = t(
    "IMPORTANT: BreatheOut is a wellness tool, not a substitute for medical or psychological treatment. If you are in immediate danger, call 911 or your local emergency number.",
    "IMPORTANTE: BreatheOut es una herramienta de bienestar, no sustituye tratamiento médico o psicológico. Si estás en peligro inmediato, llama al 911 o al número de emergencias de tu país."
  )
  static let onboardingCta = t("I Understand — Let's Begin", "Entendido — Empecemos")

  // ── Home ───────────────────────────────────────────────────────────────────
  static let homeGreetingDay = t("How are you feeling?", "¿Cómo te sientes?")
  static let homeGreetingNight = t("Still here with you.", "Aquí contigo.")
  static let helpNowBtn = t("I Need Help Now", "Necesito ayuda ahora")
  static let sosBtn = t("SOS / Hotlines", "Líneas de crisis")
  static let historyBtn = t("My Journal", "Mi diario")

  // ── Tool Selection ─────────────────────────────────────────────────────────
  static let toolTitle = t("Choose your tool", "Elige tu herramienta")
  static let breathingTitle = t("4-7-8 Breathing", "Respiración 4-7-8")
  static let breathingDesc = t("Calm your nervous system in 4 cycles.", "Calma tu sistema nervioso en 4 ciclos.")
  static let groundingTitle = t("5-4-3-2-1 Grounding", "Anclaje 5-4-3-2-1")
  static let groundingDesc = t("Reconnect your brain with the present moment.", "Reconecta tu mente con el presente.")

  // ── Breathing ──────────────────────────────────────────────────────────────
  static let breatheIn = t("Breathe In", "Inhala")
  static let holdBreath = t("Hold", "Sostén")
  static let breatheOut = t("Breathe Out", "Exhala")
  static func cycleOf(current: Int, total: Int) -> String {
    let en = "Cycle \(current) of \(total)"
    let es = "Ciclo \(current) de \(total)"
    return t(en, es)
  }
  static let breathingDone = t("Well done. You're breathing again.", "Bien hecho. Ya respiras de nuevo.")

  // ── Grounding ──────────────────────────────────────────────────────────────
  static let groundingIntro = t("Let's anchor you to this moment.", "Vamos a anclarte al presente.")
  static let groundingTap = t("Tap each time you identify one", "Toca cada vez que identifiques uno")
  static let groundingDone = t("You're back. That took courage.", "Regresaste. Eso tomó valentía.")

  static let groundingSteps: [(emoji: String, en: String, es: String)] = [
    ("👁️", "5 things you can SEE", "5 cosas que puedes VER"),
    ("✋", "4 things you can TOUCH", "4 cosas que puedes TOCAR"),
    ("👂", "3 things you can HEAR", "3 cosas que puedes ESCUCHAR"),
    ("👃", "2 things you can SMELL", "2 cosas que puedes OLER"),
    ("👅", "1 thing you can TASTE", "1 cosa que puedes SABOREAR"),
  ]

  // ── Post-Crisis ────────────────────────────────────────────────────────────
  static let postCrisisTitle = t("Glad you're back. 🌿", "Qué bueno que regresaste. 🌿")
  static let postCrisisQuestion = t("What triggered this?", "¿Qué lo desencadenó?")
  static let postCrisisSkip = t("Skip for now", "Por ahora no")
  static let postCrisisSave = t("Save & Continue", "Guardar y continuar")

  static let triggers: [(emoji: String, en: String, es: String)] = [
    ("💼", "Work", "Trabajo"),
    ("👨‍👩‍👧", "Family", "Familia"),
    ("💭", "Thoughts", "Pensamientos"),
    ("🫀", "Health", "Salud"),
    ("💑", "Relationship", "Pareja"),
    ("💸", "Money", "Dinero"),
    ("😴", "Sleep", "Sueño"),
    ("❓", "Other", "Otro"),
  ]

  // ── SOS Hotlines ───────────────────────────────────────────────────────────
  static let sosTitle = t("You are not alone.", "No estás solo/a.")
  static let sosSubtitle = t("Real people are ready to listen right now.", "Personas reales están listas para escucharte.")
  static let sosCallBtn = t("Call", "Llamar")
  static let sosTextBtn = t("Text", "Mensaje")

  // ── Paywall ────────────────────────────────────────────────────────────────
  static let paywallTitle = t("We're glad we could help. 💜", "Qué bueno que pudimos ayudarte. 💜")
  static let paywallSubtitle = t("Support BreatheOut and unlock deep insights for your therapist.", "Apoya BreatheOut y desbloquea estadísticas para tu terapeuta.")
  static let paywallMonthly = "$2.99 / month"
  static let paywallYearly = t("$14.99 / year  — Save 58%", "$14.99 / año  — Ahorra 58%")
  static let paywallCta = t("Unlock Premium", "Desbloquear Premium")
  static let paywallSkip = t("Maybe later", "Quizás después")
  static let paywallRestore = t("Restore Purchases", "Restaurar compras")

  static let premiumFeatures: [(emoji: String, en: String, es: String)] = [
    ("📊", "Monthly trend charts", "Gráficos de tendencias mensuales"),
    ("📄", "PDF export for your therapist", "Exportar PDF para tu terapeuta"),
    ("🎨", "Custom breathing themes", "Temas de respiración personalizados"),
    ("🔔", "Daily check-in reminders", "Recordatorios diarios"),
  ]

  // ── History / Journal ──────────────────────────────────────────────────────
  static let historyTitle = t("My Journal", "Mi diario")
  static let historyEmpty = t("No sessions yet. Your first entry will appear here.", "Aún no hay sesiones. Tu primera entrada aparecerá aquí.")
  static let historyExport = t("Export PDF", "Exportar PDF")

  // ── General ────────────────────────────────────────────────────────────────
  static let continueBtn = t("Continue", "Continuar")
  static let done = t("Done", "Listo")
  static let close = t("Close", "Cerrar")

  // ── Bilingual display (always show both EN + ES simultaneously) ────────────
  static let homeGreetingDayEn   = "How are you feeling?"
  static let homeGreetingDayEs   = "¿Cómo te sientes?"
  static let homeGreetingNightEn = "Still here with you."
  static let homeGreetingNightEs = "Aquí contigo."
  static let helpNowBtnEn        = "I Need Help Now"
  static let helpNowBtnEs        = "Necesito ayuda ahora"
  static let sosBtnEn            = "SOS / Hotlines"
  static let sosBtnEs            = "Líneas de crisis"
  static let toolTitleEn         = "Choose your tool"
  static let toolTitleEs         = "Elige tu herramienta"
  static let breathingTitleEn    = "4-7-8 Breathing"
  static let breathingTitleEs    = "Respiración 4-7-8"
  static let breathingDescEn     = "Calm your nervous system in 4 cycles."
  static let breathingDescEs     = "Calma tu sistema nervioso en 4 ciclos."
  static let groundingTitleEn    = "5-4-3-2-1 Grounding"
  static let groundingTitleEs    = "Anclaje 5-4-3-2-1"
  static let groundingDescEn     = "Reconnect your brain with the present moment."
  static let groundingDescEs     = "Reconecta tu mente con el presente."
  static let breatheInEs         = "Inhala"
  static let holdBreathEs        = "Sostén"
  static let breatheOutEs        = "Exhala"
  static let breathingDoneEn     = "Well done. You're breathing again."
  static let breathingDoneEs     = "Bien hecho. Ya respiras de nuevo."
  static let groundingIntroEn    = "Let's anchor you to this moment."
  static let groundingIntroEs    = "Vamos a anclarte al presente."
  static let groundingDoneEn     = "You're back. That took courage."
  static let groundingDoneEs     = "Regresaste. Eso tomó valentía."
  static let sosTitleEn          = "You are not alone."
  static let sosSubtitleEn       = "Real people are ready to listen right now."
  static let sosSubtitleEs       = "Personas reales están listas para escucharte."
  static let postCrisisTitleEs   = "Qué bueno que regresaste. 🌿"
  static let postCrisisQuestionEs = "¿Qué lo desencadenó?"
  static let postCrisisSkipEs    = "Por ahora no"
}
