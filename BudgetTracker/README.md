# Budget Tracker

A Flutter application for tracking your budget and expenses.

## Architecture

- **Feature-first structure**: Features are organized in `lib/features/`
- **State Management**: flutter_bloc
- **Routing**: go_router (Navigator 2.0)
- **Network**: Dio
- **Dependency Injection**: get_it (manual registrations)
- **Code Generation**: Freezed (only for Bloc State/Event)

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code (for Freezed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── di/           # Dependency injection setup
│   ├── network/      # Network layer (Dio client)
│   └── router/       # App routing configuration
├── features/         # Feature modules
│   └── home/         # Home feature
│       └── presentation/
│           ├── bloc/ # Bloc state management
│           └── pages/ # UI pages
└── main.dart         # App entry point
```
