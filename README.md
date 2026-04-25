# MemberCore App

**MemberCore** is a cross-platform Flutter application for managing member activity, transactions, and others across iOS and Android, built with **BLoC pattern** and **Clean Architecture (light version)**.

## 📱 Screenshots & Features

---

## Features
1. **Login Screen** — Email/password with session persistence
2. **Dashboard** — Member profile + summary cards
3. **Purchase History** — Transactions with live combined filters

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.27.3`
- **Dart SDK**: `^3.10.7`

### Installation
1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd member_dashboard_app
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

### Running the App
```bash
# Run in debug mode
flutter run

# For release mode
flutter run --release
```

### Demo Credentials
- **User ID/Email**: `MB001` or `fauzi.f@tech.com`
- **Password**: `password123`

---

## 🧪 Testing

The project includes a comprehensive suite of unit tests covering the entire logic stack.

### Running All Tests
```bash
flutter test
```
---

## 🏗️ Architecture

The app follows a **Clean Architecture** pattern to ensure maintainability and testability:

- **Domain Layer**: Contains business logic entities, abstract repository definitions, and use cases.
- **Data Layer**: Handles data retrieval from `MockDataSource`, repository implementations, and data models.
- **Presentation Layer**: Built using the **BLoC (Business Logic Component)** pattern for state management and modular UI components.

---

## 📦 Packages Used

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | Core state management for predictable UI updates. |
| `flutter_screenutil` | Responsive UI scaling across all device dimensions. |
| `equatable` | Simplifies object comparison for efficient BLoC state changes. |
| `shared_preferences` | Local persistence for user sessions and theme settings. |
| `intl` | Robust date and currency (IDR) formatting. |
| `bloc_test` | Standardized testing utility for BLoC logic. |
| `mocktail` | Null-safe mocking library for unit testing. |

---

## ⚖️ Assumptions & Tradeoffs
