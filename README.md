# Red Rocket

A Flutter application demonstrating clean architecture, authentication flow, and modern Flutter development practices.

## Features

- Clean Architecture with layer separation (data, domain, presentation)
- Authentication flow with login and logout
- Secure token storage
- Form validation
- Responsive design
- Mock API implementation
- State management with BLoC
- Dependency injection
- Route management with AutoRoute

## Tech Stack

- **State Management**: flutter_bloc
- **Navigation**: auto_route
- **Networking**: dio + retrofit
- **Dependency Injection**: get_it + injectable
- **Token Storage**: flutter_secure_storage
- **Data Classes**: freezed + json_serializable
- **Environment Config**: flutter_dotenv
- **Responsive UI**: flutter_screenutil
- **Value Equality**: equatable

## Project Structure

```
lib/
├── data/
│   ├── api/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── validation/
├── presentation/
│   ├── bloc/
│   ├── router/
│   ├── screens/
│   └── controller/
└── di/
    └── injection.dart
```

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Mock API Credentials

For testing purposes, use these credentials:
- Email: test@test.com
- Password: password123

## Validation & Controller Responsibilities

- **Form validation** is handled in the domain layer (`domain/validation/form_validators.dart`).
- **UI logic** (form state, password visibility, text controllers) is managed by a dedicated controller (`presentation/controller/login/login_screen_controller.dart`), keeping the UI layer as simple as possible.

## Architecture Overview

The app follows Clean Architecture principles with three main layers:

1. **Data Layer**
   - Handles API communication
   - Implements repositories
   - Manages data models and storage

2. **Domain Layer**
   - Contains business logic
   - Defines repository interfaces
   - Manages entities
   - Handles validation logic (e.g., form validation)

3. **Presentation Layer**
   - Implements UI
   - Manages state with BLoC
   - Handles navigation
   - Delegates UI logic to controllers for form state and input handling

This separation ensures that business logic, validation, and UI logic are all decoupled, making the codebase more maintainable and testable.
