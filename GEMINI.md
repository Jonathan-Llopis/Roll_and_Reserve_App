# Roll & Reserve - Project Instructions

## Project Overview
**Roll & Reserve** is a cross-platform mobile application (Android & iOS) designed as a table reservation platform for board game venues. It allows users to find venues, check table availability for specific games, and make reservations. Owners can manage their venues, tables, and games.

- **Frontend:** Flutter
- **State Management:** BLoC (`flutter_bloc`)
- **Architecture:** Clean Architecture (Data, Domain, Presentation layers)
- **Dependency Injection:** `get_it` (Service Locator)
- **Navigation:** `go_router`
- **Backend Integration:** REST API (NestJS/MariaDB) + Firebase (Auth, Cloud Messaging, Firestore)
- **AI Integration:** Google Gemini, DeepSeek, and custom AI assistants for coordinate games and recommendations.

## Directory Structure
- `lib/core`: Shared utilities, custom exceptions, and core application logic.
- `lib/data`: Data layer containing models (DTOs), repository implementations, and data sources (Remote & Local).
- `lib/domain`: Domain layer containing entities, repository interfaces, and use cases.
- `lib/presentation`: UI layer containing BLoCs, screens, and widgets.
- `lib/config`: Application configuration including router (`go_router`) and themes.
- `lib/l10n`: Localization files (`.arb` templates and generated Dart code).
- `assets`: Static assets including animations (Rive), icons, and images.

## Development Workflows

### Environment Setup
- Ensure a `.env` file exists in the root directory (refer to `pubspec.yaml` assets).
- Run `flutter pub get` to install dependencies.

### Code Generation
The project uses `build_runner` for various code generation tasks (e.g., JSON serialization, if applicable).
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Localization
Localization is managed using Flutter's built-in support. Add or modify `.arb` files in `lib/l10n/` and run:
```bash
flutter gen-l10n
```

### Running the App
- **Development:** `flutter run`
- **Web (Experimental):** `./run_flutter_web.sh` (if available/working)

### Testing
- **Unit & Widget Tests:** `flutter test`
- Tests are located in the `test/` directory.

## Coding Standards & Conventions
- **Clean Architecture:** Strictly adhere to the separation of concerns. Do not put business logic in the UI or data mapping in the Domain layer.
- **BLoC Pattern:** Use BLoCs for all state management. Avoid using `setState` in screens unless for strictly ephemeral UI state.
- **Dependency Injection:** Always use the `sl` (Service Locator) instance from `lib/injection.dart` to access repositories and use cases.
- **Naming Conventions:**
  - BLoCs: `[Feature]Bloc`, `[Feature]Event`, `[Feature]State`.
  - Use Cases: `[Action][Entity]UseCase`.
  - Screens: `Screen[Name]`.
- **Localization:** Always use `AppLocalizations.of(context)!` for user-facing strings. Do not hardcode text.
- **Responsiveness:** Use `flutter_screenutil` for sizing and spacing to ensure compatibility across different screen sizes.

## Key Dependencies
- `go_router`: Declarative routing.
- `flutter_bloc`: State management.
- `get_it`: Dependency injection.
- `firebase_auth` & `cloud_firestore`: Authentication and real-time data.
- `google_generative_ai` & `deepseek`: AI features.
- `rive`: High-performance animations.
- `syncfusion_flutter_charts`: Data visualization for owner statistics.
