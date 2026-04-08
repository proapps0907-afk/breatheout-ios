# BreatheOut - iOS Native (Swift/SwiftUI)

Migración completa de Flutter a Swift nativo para iOS App Store.

## 📁 Estructura del Proyecto

```
ios-swift/
└── BreatheOut.xcodeproj/
└── BreatheOut/
    ├── BreatheOutApp.swift      # Entry point + App struct
    ├── Colors.swift             # Paleta de colores idéntica a Flutter
    ├── L10n.swift               # Strings bilingües (EN/ES)
    ├── CrisisEntry.swift        # Modelo + StorageManager
    ├── Store.swift              # ViewModel principal (ObservableObject)
    ├── Utils.swift              # Haptics, extensions
    ├── OnboardingView.swift     # Pantalla de onboarding
    ├── HomeView.swift           # Pantalla principal
    ├── BreathingView.swift      # Técnica 4-7-8
    ├── GroundingView.swift      # Técnica 5-4-3-2-1
    ├── SOSView.swift            # Líneas de crisis
    ├── JournalView.swift        # Historial de sesiones
    └── PostCrisisView.swift     # Registro post-crisis
    └── Assets.xcassets/         # Assets del proyecto
```

## 🎨 Diseño Conservado

| Elemento | Flutter | SwiftUI |
|----------|---------|---------|
| Colores | `AppColors` | `AppColors` (mismo hex) |
| Tipografía | Google Fonts Nunito | System fonts (similar) |
| Gradientes | `LinearGradient` | `LinearGradient` |
| Dark Mode | `ThemeData.dark` | `.preferredColorScheme(.dark)` |

## 🚀 Cómo Abrir

1. Abre `ios-swift/BreatheOut.xcodeproj` en Xcode 15+
2. Selecciona tu equipo de desarrollo
3. Presiona ⌘R para ejecutar en simulador o dispositivo

## 📱 Requisitos

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 🔄 Diferencias vs Flutter

| Flutter | SwiftUI |
|---------|---------|
| `Provider` | `@EnvironmentObject` |
| `ChangeNotifier` | `ObservableObject` |
| `setState` | `@State` / `@Published` |
| `Hive` | `UserDefaults` + `Codable` |
| `Navigator.push` | `.sheet()` / `.fullScreenCover()` |
| `Container` | `VStack`/`HStack`/`ZStack` |

## 📦 Persistencia

- **UserDefaults**: Flags (onboarding, premium, idioma)
- **Codable JSON**: Entradas de crisis serializadas

## 🌐 Localización

Cambio de idioma EN/ES en tiempo real desde el toggle en HomeView.

## ⚠️ Notas

- Los errores de SourceKit en el editor son normales hasta compilar
- Al compilar en Xcode, todo debería funcionar
- Agregar ícono de app en `Assets.xcassets/AppIcon.appiconset`
